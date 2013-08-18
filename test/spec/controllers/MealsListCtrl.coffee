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

  it 'sets the meals', ->
    expect(scope.meals).not.toBeUndefined()

  it 'sets the route parameters', ->
    expect(scope.$routeParams.mealId).toEqual "1"

  describe "when a mealupdated event is fired", ->
    beforeEach inject ($rootScope) ->
      scope.meals = [{_id:'asdf', name: 'Meal'}, {_id:'qwer', name: 'Other Meal'}]
      scope.$broadcast "mealupdated",
        _id: 'qwer'
        name: 'Delicious Meal'
      scope.$apply()

    it "updates the data in the matching meal", ->
      expect(scope.meals[1].name).toEqual "Delicious Meal"

    it "does not update the data in other meals", ->
      expect(scope.meals[0].name).toEqual "Meal"
