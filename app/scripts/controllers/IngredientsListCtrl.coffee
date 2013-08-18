angular.module('emeals').controller 'IngredientsListCtrl', ($scope) ->
  $scope.$watch 'meal', ->
    $scope.ingredients = $scope.meal[$scope.type].ingredients
