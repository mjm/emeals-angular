emeals = angular.module('emeals', ['restangular', 'blueimp.fileupload'])

emeals.config ($routeProvider) ->
  $routeProvider.when '/',
    templateUrl: 'views/home.html'
  .when '/meals/:mealId',
    templateUrl: 'views/show.html'
    controller: 'MealShowCtrl'
    resolve:
      meal: ['Meals', (Meals) -> Meals.load()]
  .when '/meals/:mealId/edit',
    templateUrl: 'views/edit.html'
    controller: 'MealEditCtrl'
    resolve:
      meal: ['Meals', (Meals) -> Meals.load()]
  .when '/plans/new',
    templateUrl: 'views/plan_edit.html'
    controller: 'PlanNewCtrl'
  .when '/plans/:id',
    templateUrl: 'views/plan.html'
    controller: 'PlanShowCtrl'
    resolve:
      plan: ['Plans', (Plans) -> Plans.load()]
  .when '/plans/:id/edit',
    templateUrl: 'views/plan_edit.html'
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
