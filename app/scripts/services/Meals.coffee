angular.module('emeals.services').factory 'Meals', (Restangular, $route) ->
  Meals =
    all: ->
      Restangular.all('meals').getList()

    load: ->
      Restangular.one('meals', $route.current.params.mealId).get()
