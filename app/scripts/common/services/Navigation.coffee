angular.module('emeals.common').factory 'Navigation', ($location) ->
  isViewingMeals: ->
    /^\/($|meals)/.test $location.path()

  isViewingPlans: ->
    /^\/plans/.test $location.path()
