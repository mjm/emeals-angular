angular.module('emeals.meals').factory 'Meals', (Restangular, $route) ->
  Meals =
    all: ->
      Restangular.all('meals').getList()

    search: (query) ->
      if query is ''
        Meals.all()
      else
        Restangular.all('meals').customGETLIST('search', {q: query})

    load: ->
      Restangular.one('meals', $route.current.params.mealId).get()
