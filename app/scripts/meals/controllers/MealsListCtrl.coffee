angular.module('emeals.meals').controller 'MealsListCtrl', ($scope, $routeParams, Meals, Navigation, Errors) ->
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

  $scope.$on "fileuploaddone", (e, data) ->
    failureCount = data.result.failures.length
    successCount = data.result.successes.length

    if failureCount > 0
      Errors.setWarning "#{successCount} meals imported. #{failureCount} failed to import."
    else
      Errors.setSuccess "#{successCount} meals imported."

    loadMeals()

  $scope.$on "fileuploadfail", ->
    Errors.setError "An error occurred while importing. The error was logged."
