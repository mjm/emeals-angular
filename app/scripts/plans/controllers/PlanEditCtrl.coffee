angular.module('emeals.plans').controller 'PlanEditCtrl', ($scope, plan, $location, Errors) ->
  $scope.plan = plan
  $scope.isNew = false

  $scope.cancel = ->
    $location.path "/plans/#{plan._id}"

  $scope.save = ->
    $scope.plan.put().then (-> $scope.cancel()), Errors.defaultHandler
