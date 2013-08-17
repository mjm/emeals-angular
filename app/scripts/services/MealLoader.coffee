angular.module('emeals').factory 'MealLoader', ($route, Restangular) ->
  -> Restangular.one('meals', $route.current.params.mealId).get()
