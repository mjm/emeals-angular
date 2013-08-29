angular.module('emeals').controller 'PlanNewCtrl', ($scope, Dates, $location, Restangular) ->
  $scope.plan =
    name: ""
    days:
      start: Dates.today()
      end: Dates.daysLater(6)
    meals: {}
  $scope.isNew = true

  $scope.cancel = ->
    $location.path '/plans/current'

  $scope.save = ->
    Restangular.all('plans').post($scope.plan).then (result) ->
      $location.path "/plans/#{result.id}"
