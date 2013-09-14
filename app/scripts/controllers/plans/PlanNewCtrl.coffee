angular.module('emeals.controllers').controller 'PlanNewCtrl', ($scope, Dates, $location, Plans, Errors) ->
  $scope.plan =
    name: ""
    days:
      start: Dates.today()
      end: Dates.daysLater(6)
    meals: {}
  $scope.isNew = true

  $scope.cancel = -> $location.path '/plans/current'

  $scope.save = ->
    Plans.create($scope.plan).then (result) ->
      $location.path "/plans/#{result.id}"
    , Errors.defaultHandler
