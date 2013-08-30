angular.module('emeals.filters').filter 'capitalize', ->
  (input) -> _.capitalize(input)
