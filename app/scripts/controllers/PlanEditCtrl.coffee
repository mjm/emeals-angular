angular.module('emeals').controller 'PlanEditCtrl', ($scope, plan, $location) ->
  $scope.plan = plan

  $scope.cancel = ->
    $location.path "/plans/#{plan._id}"

  $scope.save = ->
    $scope.plan.put().then ->
      $scope.cancel()
