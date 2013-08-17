angular.module('emeals').factory 'MealsLoader', (Restangular) ->
  -> Restangular.all('meals').getList()
