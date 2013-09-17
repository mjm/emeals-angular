angular.module('emeals.common').directive 'let', ->
  restrict: 'E'
  scope: true
  link: ($scope, elem, attrs) ->
    assign = (value) -> $scope[attrs.name] = value
    assign($scope.$eval attrs.value)
    $scope.$watch attrs.name, assign
