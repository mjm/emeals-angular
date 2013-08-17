angular.module('emeals').factory 'MealLoader', ($q, $route, Meal) ->
  ->
    delay = $q.defer()
    mealId = $route.current.params.mealId
    Meal.get(id: mealId, (meal) ->
      delay.resolve(meal)
    , ->
      delay.reject("Unable to fetch meal #{mealId}"))
    delay.promise

