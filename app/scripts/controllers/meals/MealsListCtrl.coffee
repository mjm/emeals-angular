angular.module('emeals.controllers').controller 'MealsListCtrl', ($scope, $routeParams, Meals, Navigation) ->
  loadMeals = ->
    $scope.meals = Meals.all()
    $scope.meals.then (meals) ->
      $scope.meals = meals

  loadMeals()
  $scope.$routeParams = $routeParams
  $scope.nav = Navigation

  $scope.$on "mealupdated", (e, meal) ->
    existingMeal = _.find $scope.meals, _id: meal._id
    _.extend existingMeal, meal

  $scope.$on "mealdeleted", (e, meal) ->
    index = _.findIndex $scope.meals, _id: meal._id
    $scope.meals.splice index, 1

  $scope.$on "fileuploaddone", loadMeals
