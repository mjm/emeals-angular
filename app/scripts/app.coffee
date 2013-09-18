emeals = angular.module 'emeals',
  ['blueimp.fileupload',
   'emeals.meals',
   'emeals.plans']

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

  .when '/plans',
    templateUrl: 'views/plans/list.html'
    controller: 'PlanListCtrl'
    resolve:
      pastPlans:   ['Plans', (Plans) -> Plans.past()]
      futurePlans: ['Plans', (Plans) -> Plans.future()]
      current:     ['Plans', (Plans) -> Plans.load('current')]

  .when '/plans/new',
    templateUrl: 'views/plans/edit.html'
    controller: 'PlanNewCtrl'

  .when '/plans/:id',
    templateUrl: 'views/plans/show.html'
    controller: 'PlanShowCtrl'
    resolve:
      plan: ['Plans', (Plans) -> Plans.load()]

  .when '/plans/:id/shopping_list',
    templateUrl: 'views/plans/shopping_list.html'
    controller: 'ShoppingListCtrl'
    resolve:
      plan: ['Plans', (Plans) -> Plans.load()]
      shoppingList: ['Plans', (Plans) -> Plans.shoppingList()]

  .when '/plans/:id/edit',
    templateUrl: 'views/plans/edit.html'
    controller: 'PlanEditCtrl'
    resolve:
      plan: ['Plans', (Plans) -> Plans.load()]

  .otherwise
    redirectTo: '/'

emeals.config ($locationProvider) ->
  $locationProvider.html5Mode(true)
