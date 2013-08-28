angular.module('emeals').controller 'PlanEditCtrl', ($scope, plan, $location, Plans) ->
  $scope.plan = plan
  $scope.isNew = false
  $scope.mealsByDay = Plans.mealsByDay plan

  $scope.$watch 'plan.days', (->
    $scope.dayRange = Plans.rangeForDays plan), true

  $scope.isDayHidden = (day) ->
    not _.contains($scope.dayRange, day)

  $scope.cancel = ->
    $location.path "/plans/#{plan._id}"

  $scope.save = ->
    $scope.plan.put().then ->
      $scope.cancel()
