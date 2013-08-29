emeals = angular.module('emeals', ['restangular', 'blueimp.fileupload'])

emeals.config ($routeProvider) ->
  $routeProvider.when '/',
    templateUrl: 'views/meals/home.html'
  .when '/meals/:mealId',
    templateUrl: 'views/meals/show.html'
    controller: 'MealShowCtrl'
    resolve:
      meal: ['Meals', (Meals) -> Meals.load()]
  .when '/meals/:mealId/edit',
    templateUrl: 'views/meals/edit.html'
    controller: 'MealEditCtrl'
    resolve:
      meal: ['Meals', (Meals) -> Meals.load()]
  .when '/plans/new',
    templateUrl: 'views/plans/edit.html'
    controller: 'PlanNewCtrl'
  .when '/plans/:id',
    templateUrl: 'views/plans/show.html'
    controller: 'PlanShowCtrl'
    resolve:
      plan: ['Plans', (Plans) -> Plans.load()]
  .when '/plans/:id/edit',
    templateUrl: 'views/plans/edit.html'
    controller: 'PlanEditCtrl'
    resolve:
      plan: ['Plans', (Plans) -> Plans.load()]
  .otherwise
    redirectTo: '/'

emeals.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl "/api"
  RestangularProvider.setRestangularFields
    id: "_id"

emeals.config ($locationProvider) ->
  $locationProvider.html5Mode(true)

_.mixin _.string.exports()
