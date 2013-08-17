angular.module('emeals').controller 'MealEditCtrl', ($scope, $rootScope, $location, meal) ->
  $scope.meal = meal

  $scope.cancel = ->
    $location.path "/meals/#{meal.id}"

  $scope.save = ->
    meal.put().then ->
      $rootScope.$broadcast "mealupdated", meal
      $location.path "/meals/#{meal.id}"
