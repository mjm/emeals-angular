angular.module('emeals.common').filter 'ingredient', ->
  (ingredient) ->
    "#{ingredient.amount || ''} #{ingredient.unit || ''} #{ingredient.description}"
