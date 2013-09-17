mealCount = (plan) ->
  _.flatten(_.values(plan.meals)).length

angular.module('emeals.plans').controller 'PlanShowCtrl', ($scope, plan, Plans, $window, $location) ->
  $scope.plan = plan

  $scope.remove = (day, index) ->
    $scope.plan.meals[day].splice(index, 1)

  $scope.removePlan = ->
    if $window.confirm "Are you sure you want to delete the plan?"
      $scope.plan.remove(_rev: $scope.plan._rev).then ->
        $location.path "/plans"

  $scope.$watch 'plan', ->
    $scope.groupedMealsByDay = _.groupBy Plans.mealsByDay($scope.plan), (value, index) ->
      Math.floor index / 3

  $scope.$watch (-> mealCount $scope.plan), (newValue, oldValue) ->
    if newValue isnt oldValue
      $scope.plan.put().then (result) ->
        $scope.plan._rev = result.rev

