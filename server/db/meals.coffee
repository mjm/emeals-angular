_ = require 'underscore'
exec = require('child_process').exec
path = require 'path'
util = require 'util'

cradle = require 'cradle'
db = new(cradle.Connection)(cache: false).database 'meals'

ejs = require 'elastic.js'
NodeClient = require('elastic.js/elastic-node-client').NodeClient

ejs.client = NodeClient('localhost', '9200')

exports.all = (callback) ->
  db.view 'meals/by_entree_name',
    include_docs: true
  , (err, results) ->
    if err
      callback err, null
    else
      callback err, _.pluck(results, 'doc')

exports.search = (query, callback) ->
  query = ejs.MatchQuery "_all", query
  request = ejs.Request().indices("meals").types("meal").query(query)

  try
    request.doSearch (results) ->
      if results.hits
        callback null, _.pluck(results.hits.hits, '_source')
      else
        callback
          error: "not_found"
          message: "Search results could not be found."
        , null
  catch e
    callback
      error: "internal_server_error"
      message: "The search backend had a problem."
    , null

exports.get = (id, callback) ->
  db.get id, callback

exports.update = (meal, callback) ->
  db.save meal._id, meal._rev, _.omit(meal, '_id', '_rev'), callback

exports.delete = (id, rev, callback) ->
  db.remove id, rev, callback

parserJarPath = ->
  path.join __dirname, '..', '..', 'external', 'parser.jar'

importCommandForMenu = (menu) ->
  "java -jar #{parserJarPath()} #{menu}"

handleImportFailure = (err, callback) ->
  util.error "Command errored. This should not have happened.", err
  callback
    error: "internal_server_error"
    message: "The meal importer had a problem. The error has been logged."
  , ""

handleImportSuccess = (meals, callback) ->
  results = []
  process = (meal) ->
    if meal
      util.debug "Processing meal #{results.length + 1}..."
      db.save meal, (err, res) ->
        results.push res
        process meals.successes.shift()
    else
      util.debug "Processed all meals."
      callback null,
        successes: results
        failures: meals.failures
  process meals.successes.shift()

exports.import = (menu, callback) ->
  command = importCommandForMenu(menu)

  util.log "Running import command: #{command}"
  exec command, (err, out) ->
    if err
      # I'm deeply disappointed in you...
      handleImportFailure err, callback
    else
      handleImportSuccess JSON.parse(out), callback
