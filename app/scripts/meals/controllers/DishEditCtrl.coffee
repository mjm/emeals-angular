angular.module('emeals.meals').controller 'DishEditCtrl', ($scope) ->
  $scope.unitChoices = [
    "teaspoon",
    "tablespoon",
    "cup",
    "oz",
    "lb",
    "clove"
  ].sort()

  $scope.$watch 'meal', ->
    $scope.dish = $scope.meal[$scope.type]

  $scope.remove = (index) ->
    $scope.dish.ingredients.splice index, 1

  $scope.add = ->
    $scope.dish.ingredients ||= []
    $scope.dish.ingredients.push
      amount: ""
      unit: ""
      description: ""
