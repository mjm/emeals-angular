angular.module('emeals.services').factory 'Plans', (Dates, Restangular, $route) ->
  Plans =
    load: ->
      Restangular.one('plans', $route.current.params.id).get()

    create: (plan) ->
      Restangular.all('plans').post(plan)

    past: ->
      Restangular.all('plans').customGETLIST('past')

    # Returns a list of all the day keys between the plan's
    # start and end day, inclusive.
    rangeForDays: (plan) ->
      currentDate = new Date(plan.days.start)
      endDate = new Date(plan.days.end)
      days = []
      while currentDate <= endDate and days.length < 10
        days.push currentDate
        currentDate = new Date(currentDate)
        currentDate.setDate currentDate.getDate() + 1
      _.map days, Dates.format

    mealsByDay: (plan) ->
      _.map Plans.rangeForDays(plan), (day) ->
        plan.meals[day] ||= []

        day: day
        meals: plan.meals[day]
