describe "Controller: MealsListCtrl", ->

  MealsListCtrl = scope = mealsDeferred = params = undefined

  beforeEach module('emeals')
  beforeEach inject ($controller, $rootScope, $q) ->
    scope = $rootScope.$new()
    mealsDeferred = $q.defer()
    params = {mealId: "1"}
    MealsListCtrl = $controller 'MealsListCtrl',
      $scope: scope
      $routeParams: params
      MealsLoader: -> mealsDeferred.promise

  it 'has no meals when the meals have not loaded yet', ->
    expect(scope.meals).toBeUndefined()

  it 'sets the route parameters', ->
    expect(scope.$routeParams.mealId).toEqual "1"

  describe 'when the meals have loaded', ->
    beforeEach ->
      mealsDeferred.resolve []
      scope.$apply()

    it 'sets the meals', ->
      expect(scope.meals).toEqual []
