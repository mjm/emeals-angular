angular.module('emeals').factory 'MealsLoader', ($q, Meal) ->
  ->
    delay = $q.defer()
    Meal.query (meals) ->
      delay.resolve(meals)
    , ->
      delay.reject("Unable to fetch meals.")
    delay.promise
