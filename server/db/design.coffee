plansDesign =
  "_id": "_design/plans"
  "views":
    "current":
      "map": "function(doc) { emit(doc.days.end, null); }"

mealsDesign =
  "_id": "_design/meals"
  "views":
    "by_entree_name":
      "map": "function(doc) { emit(doc.entree.name, null); }"

cradle = require 'cradle'
mealDb = new(cradle.Connection)(cache: false).database 'meals'
planDb = new(cradle.Connection)(cache: false).database 'plans'

importDesignIntoDb = (doc, db) ->
  db.save doc._id, doc, (err, res) ->
    if err
      console.error "An error occurred trying to import design '#{doc._id}'."
      console.error err
    else
      console.log "Successfully imported design '#{doc._id}'."

exports.destroyDatabases = ->
  [['meals', mealDb], ['plans', planDb]].forEach (db) ->
    db[1].destroy (err, res) ->
      if err
        console.error "An error occurred trying to destroy the #{db[0]} database."
        console.error err
      else
        console.log "Successfully destroyed the #{db[0]} database."
    db[1].create()

exports.importPlansDesign = ->
  importDesignIntoDb plansDesign, planDb

exports.importMealsDesign = ->
  importDesignIntoDb mealsDesign, mealDb

exports.importAll = ->
  exports.importMealsDesign()
  exports.importPlansDesign()

exports.destroyAndImportAll = ->
  exports.destroyDatabases()
  exports.importAll()
