angular.module('emeals.plans').factory 'Plans', (Dates, Restangular, $route) ->
  Plans =
    load: (id = $route.current.params.id) ->
      Restangular.one('plans', id).get()

    shoppingList: (id = $route.current.params.id) ->
      Restangular.one('plans', id).customGET('shopping_list')

    create: (plan) ->
      Restangular.all('plans').post(plan)

    past: ->
      Restangular.all('plans').customGETLIST('past')

    future: ->
      Restangular.all('plans').customGETLIST('future')

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
