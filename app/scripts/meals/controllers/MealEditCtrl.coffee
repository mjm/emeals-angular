angular.module('emeals.meals').controller 'MealEditCtrl', ($scope, $rootScope, $location, meal, Errors) ->
  $scope.meal = meal

  $scope.cancel = ->
    $location.path "/meals/#{meal._id}"

  $scope.save = ->
    meal.put().then ->
      $rootScope.$broadcast "mealupdated", meal
      $location.path "/meals/#{meal._id}"
    , Errors.defaultHandler
