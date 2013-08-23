angular.module('emeals').factory 'PlanLoader', (Restangular) ->
  -> Restangular.one('plans', 'current').get()
