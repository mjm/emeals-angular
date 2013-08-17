emeals = angular.module('emeals', ['ngResource'])

emeals.config ($routeProvider) ->
  $routeProvider.when '/',
    templateUrl: 'views/home.html'
  .when '/meals/:mealId',
    templateUrl: 'views/show.html'
    controller: 'MealShowCtrl'
    resolve:
      meal: (MealLoader) ->
        MealLoader()
  .when '/meals/:mealId/edit',
    templateUrl: 'views/edit.html'
    controller: 'MealEditCtrl'
    resolve:
      meal: (MealLoader) ->
        MealLoader()
  .otherwise
    redirectTo: '/'

#emeals.config ($locationProvider) ->
  #$locationProvider.html5Mode true
