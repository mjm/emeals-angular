meals = require './db/meals'
errors = require './errors'

exports.index = (req, res) ->
  meals.all errors.handler(res)

exports.search = (req, res) ->
  meals.search req.query.q, errors.handler(res)

exports.show = (req, res) ->
  meals.get req.params.id, errors.handler(res)

exports.update = (req, res) ->
  meals.update req.body, errors.handler(res)

exports.destroy = (req, res) ->
  meals.delete req.params.id, req.query._rev, errors.handler(res)

exports.import = (req, res) ->
  meals.import req.files.menu.path, (err, result) ->
    res.send result
