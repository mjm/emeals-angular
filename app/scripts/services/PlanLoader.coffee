angular.module('emeals').factory 'PlanLoader', (Restangular, $route) ->
  -> Restangular.one('plans', $route.current.params.id).get()
