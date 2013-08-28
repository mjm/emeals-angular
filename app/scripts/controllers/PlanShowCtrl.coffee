mealCount = (plan) ->
  _.flatten(_.values(plan.meals)).length

angular.module('emeals').controller 'PlanShowCtrl', ($scope, plan, Plans) ->
  $scope.plan = plan

  $scope.remove = (day, index) ->
    $scope.plan.meals[day].splice(index, 1)

  $scope.$watch 'plan', ->
    $scope.groupedMealsByDay = _.groupBy Plans.mealsByDay($scope.plan), (value, index) ->
      Math.floor index / 3

  $scope.$watch (-> mealCount $scope.plan), (newValue, oldValue) ->
    if newValue isnt oldValue
      $scope.plan.put().then (result) ->
        $scope.plan._rev = result.rev

