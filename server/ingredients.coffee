_ = require 'underscore'
_.mixin(require 'underscore.inflections')
_s = require 'underscore.string'
Ratio = require 'lb-ratio'

category = require './category'

mealsFromPlan = (plan) ->
  _.flatten _.values(plan.meals)

combine = (meals) ->
  _.flatten [
    _.pluck(_.pluck(meals, 'entree'), 'ingredients'),
    _.pluck(_.pluck(meals, 'side'), 'ingredients')
  ]

sort = (ingredients) ->
  _.sortBy ingredients, (ingredient) ->
    ingredient.description.toLowerCase()

normalize = (desc) ->
  _.singularize(desc.replace('large ', '').replace(/,.+$/, ''))

normalizeAll = (ingredients) ->
  normalized = {}
  _.each ingredients, (ingredient) ->
    key = normalize(ingredient.description)
    normalized[key] ||= []
    normalized[key].push(ingredient)
  normalized

combineIngredients = (ing, nextIng) ->
  if ing.unit == nextIng.unit
    amount: ing.amount.add(Ratio.parse(nextIng.amount))
    unit: ing.unit
  else
    ing

merge = (ingredients, desc) ->
  ingredient = _.reduce ingredients, (ing, nextIng) ->
    if ing
      _.extend ing, combineIngredients(ing, nextIng)
    else
      _.extend nextIng,
        amount: Ratio.parse(nextIng.amount)
        description: desc
  , null

  _.extend ingredient,
    amount: ingredient.amount.simplify().toLocaleString()
    category: category.detect(ingredient)

mergeAll = (normalized) ->
  _.groupBy sort(_.map normalized, merge), 'category'

exports.fromPlan = (plan) ->
  mergeAll normalizeAll combine(mealsFromPlan plan)
