angular.module('emeals.plans').controller 'ScheduledMealsCtrl', ($scope, Plans) ->
  $scope.$watch 'plan', (plan) ->
    $scope.mealsByDay = Plans.mealsByDay plan

  $scope.$watch 'plan.days', (->
    $scope.dayRange = Plans.rangeForDays $scope.plan), true

  $scope.isDayHidden = (day) ->
    not _.contains($scope.dayRange, day)
