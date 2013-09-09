_ = require 'underscore'
cradle = require 'cradle'
dateFormat = require 'dateformat'

db = new(cradle.Connection)(cache: false).database 'plans'

today = -> dateFormat 'isoDate'

daysLater = (days) ->
  date = new Date()
  date.setDate date.getDate() + days
  dateFormat date, 'isoDate'

createCurrentPlan = (callback) ->
  plan =
    name: "My Weekly Meal Plan"
    days:
      start: today()
      end: daysLater(6)
    meals: {}

  db.save plan, (err, res) ->
    if err
      callback err, null
    else
      plan._id = res.id
      plan._rev = res.rev
      callback err, plan

exports.getCurrent = (callback) ->
  db.view 'plans/current',
    limit: 1
    startkey: today()
    include_docs: true
  , (err, results) ->
    if err
      callback err, null
    else if not results[0]
      createCurrentPlan callback
    else
      callback err, results[0].doc

exports.allPast = (callback) ->
  db.view 'plans/current',
    endkey: daysLater(-1)
    include_docs: true
  , (err, results) ->
    callback err, _.map(results, (result) -> result.doc)

exports.allFuture = (callback) ->
  db.view 'plans/current',
    startkey: today()
    skip: 1
    include_docs: true
  , (err, results) ->
    callback err, _.map(results, (result) -> result.doc)

exports.get = (id, callback) ->
  db.get id, callback

exports.create = (plan, callback) ->
  db.save plan, callback

exports.update = (plan, callback) ->
  db.save plan._id, plan._rev, _.omit(plan, '_id', '_rev'), callback

exports.delete = (id, rev, callback) ->
  db.remove id, rev, callback
