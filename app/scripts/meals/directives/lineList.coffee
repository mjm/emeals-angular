angular.module('emeals.meals').directive 'lineList', ->
  scope:
    text: '=text'
  restrict: 'EA'
  template: '<li ng-repeat="line in lines">{{line}}</li>'
  replace: true
  link: ($scope, elem, attrs) ->
    $scope.lines = $scope.text?.split("\n")

