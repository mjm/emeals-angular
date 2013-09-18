angular.module('emeals.common').filter 'ingredient', ->
  (ingredient) ->
    _.clean("#{ingredient.amount || ''} #{ingredient.unit || ''} #{ingredient.description}")
