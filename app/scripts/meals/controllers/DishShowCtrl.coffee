angular.module('emeals.meals').controller 'DishShowCtrl', ($scope) ->
  $scope.$watch 'meal', ->
    $scope.dish = $scope.meal[$scope.type]
