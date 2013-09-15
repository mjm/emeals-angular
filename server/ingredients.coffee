_ = require 'underscore'
_.mixin(require 'underscore.inflections')
_s = require 'underscore.string'
Ratio = require 'lb-ratio'

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

mergeAll = (normalized) ->
  _.map normalized, merge

exports.fromPlan = (plan) ->
  sort mergeAll(normalizeAll(combine(mealsFromPlan plan)))
