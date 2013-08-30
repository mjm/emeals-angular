emeals = angular.module 'emeals',
  ['blueimp.fileupload',
   'emeals.services',
   'emeals.directives',
   'emeals.filters',
   'emeals.controllers']

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

emeals.config ($locationProvider) ->
  $locationProvider.html5Mode(true)
