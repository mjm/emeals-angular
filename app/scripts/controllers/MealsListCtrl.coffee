angular.module('emeals').controller 'MealsListCtrl', ($scope, $routeParams, MealsLoader) ->
  $scope.meals = MealsLoader()
  $scope.meals.then (meals) ->
    $scope.meals = meals
  $scope.$routeParams = $routeParams

  $scope.$on "mealupdated", (e, meal) ->
    existingMeal = _.find $scope.meals, id: meal.id
    _.extend existingMeal, meal
