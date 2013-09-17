angular.module('emeals.meals').controller 'MealShowCtrl', ($scope, $rootScope, $location, $window, meal) ->
  $scope.meal = meal

  $scope.remove = ->
    if $window.confirm "Are you sure you want to delete the meal?"
      meal.remove(_rev: meal._rev).then ->
        $rootScope.$broadcast "mealdeleted", meal
        $location.path "/"
