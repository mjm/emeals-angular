angular.module('emeals.plans').controller 'PlanListCtrl', ($scope, pastPlans, futurePlans, current) ->
  $scope.pastPlans = pastPlans
  $scope.futurePlans = futurePlans
  $scope.current = current
