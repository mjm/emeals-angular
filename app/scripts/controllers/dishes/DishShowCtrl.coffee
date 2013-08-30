angular.module('emeals.controllers').controller 'DishShowCtrl', ($scope) ->
  $scope.$watch 'meal', ->
    $scope.dish = $scope.meal[$scope.type]
