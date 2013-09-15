db = require './db/plans'
errors = require './errors'
ing = require './ingredients'

exports.current = (req, res) ->
  db.getCurrent errors.handler(res)

exports.past = (req, res) ->
  db.allPast errors.handler(res)

exports.future = (req, res) ->
  db.allFuture errors.handler(res)

exports.show = (req, res) ->
  db.get req.params.id, errors.handler(res)

exports.create = (req, res) ->
  db.create req.body, errors.handler(res)

exports.update = (req, res) ->
  db.update req.body, errors.handler(res)

exports.destroy = (req, res) ->
  db.delete req.params.id, req.query._rev, errors.handler(res)

exports.shoppingList = (req, res) ->
  db.get req.params.id, (err, plan) ->
    errors.handle res, err, {categories: ing.fromPlan(plan)}
