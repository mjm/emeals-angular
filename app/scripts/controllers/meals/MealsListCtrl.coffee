angular.module('emeals.controllers').controller 'MealsListCtrl', ($scope, $routeParams, Meals, Navigation) ->
  $scope.$routeParams = $routeParams
  $scope.nav = Navigation
  $scope.search = {query: ''}

  loadMeals = ->
    $scope.meals = Meals.search($scope.search.query)
    $scope.meals.then (meals) ->
      $scope.meals = meals
  loadMeals()

  $scope.$watch 'search.query', loadMeals

  $scope.$on "mealupdated", (e, meal) ->
    existingMeal = _.find $scope.meals, _id: meal._id
    _.extend existingMeal, meal

  $scope.$on "mealdeleted", (e, meal) ->
    index = _.findIndex $scope.meals, _id: meal._id
    $scope.meals.splice index, 1

  $scope.$on "fileuploaddone", loadMeals
