angular.module('emeals').controller 'MealsListCtrl', ($scope, $routeParams, MealsLoader) ->
  MealsLoader().then (meals) ->
    $scope.meals = meals
  $scope.$routeParams = $routeParams
