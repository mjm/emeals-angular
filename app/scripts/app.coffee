emeals = angular.module('emeals', ['restangular', 'blueimp.fileupload'])

emeals.config ($routeProvider) ->
  $routeProvider.when '/',
    templateUrl: 'views/home.html'
  .when '/meals/:mealId',
    templateUrl: 'views/show.html'
    controller: 'MealShowCtrl'
    resolve:
      meal: ['MealLoader', (MealLoader) -> MealLoader()]
  .when '/meals/:mealId/edit',
    templateUrl: 'views/edit.html'
    controller: 'MealEditCtrl'
    resolve:
      meal: ['MealLoader', (MealLoader) -> MealLoader()]
  .when '/plans/new',
    templateUrl: 'views/plan_edit.html'
    controller: 'PlanNewCtrl'
  .when '/plans/:id',
    templateUrl: 'views/plan.html'
    controller: 'PlanShowCtrl'
    resolve:
      plan: ['PlanLoader', (PlanLoader) -> PlanLoader()]
  .when '/plans/:id/edit',
    templateUrl: 'views/plan_edit.html'
    controller: 'PlanEditCtrl'
    resolve:
      plan: ['PlanLoader', (PlanLoader) -> PlanLoader()]
  .otherwise
    redirectTo: '/'

emeals.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl "/api"
  RestangularProvider.setRestangularFields
    id: "_id"

_.mixin _.string.exports()
