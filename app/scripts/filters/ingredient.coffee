angular.module('emeals.filters').filter 'ingredient', ->
  (ingredient) ->
    "#{ingredient.amount || ''} #{ingredient.unit || ''} #{ingredient.description}"
