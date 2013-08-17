angular.module('emeals').factory 'Meal', ($resource) ->
  $resource '/api/meals/:id', {id: '@id'}
