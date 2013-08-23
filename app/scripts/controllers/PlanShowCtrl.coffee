# Returns a list of all the day keys between the plan's
# start and end day, inclusive.
rangeForDays = (plan) ->
  currentDate = new Date(plan.days.start)
  endDate = new Date(plan.days.end)
  days = []
  while currentDate <= endDate and days.length < 10
    days.push currentDate
    currentDate = new Date(currentDate)
    currentDate.setDate currentDate.getDate() + 1
  _.map days, (date) -> date.toJSON().slice(0, 10)

mealsByDay = (plan) ->
  _.map rangeForDays(plan), (day) ->
    day: day
    meals: plan.meals[day] || []

angular.module('emeals').controller 'PlanShowCtrl', ($scope, plan) ->
  $scope.$watch 'plan', ->
    $scope.groupedMealsByDay = _.groupBy mealsByDay($scope.plan), (value, index) ->
      Math.floor index / 3

  $scope.plan = plan
