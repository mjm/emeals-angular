angular.module('emeals.controllers').controller 'PlanListCtrl', ($scope, pastPlans, futurePlans) ->
  $scope.pastPlans = pastPlans
  $scope.futurePlans = futurePlans
