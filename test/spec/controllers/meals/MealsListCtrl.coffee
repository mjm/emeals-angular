describe "Controller: MealsListCtrl", ->

  MealsListCtrl = Meals = scope = mealsDeferred = params = undefined

  beforeEach module('emeals.controllers')
  beforeEach inject ($controller, $rootScope, $q) ->
    scope = $rootScope.$new()
    mealsDeferred = $q.defer()
    params = {mealId: "1"}
    Meals = {all: jasmine.createSpy("MealsLoader").andCallFake -> mealsDeferred.promise}
    MealsListCtrl = $controller 'MealsListCtrl',
      $scope: scope
      $routeParams: params
      Meals: Meals

  it 'sets the meals', ->
    expect(scope.meals).not.toBeUndefined()

  it 'sets the route parameters', ->
    expect(scope.$routeParams.mealId).toEqual "1"

  describe "when a mealupdated event is fired", ->
    beforeEach ->
      scope.meals = [{_id:'asdf', name: 'Meal'}, {_id:'qwer', name: 'Other Meal'}]
      scope.$broadcast "mealupdated",
        _id: 'qwer'
        name: 'Delicious Meal'
      scope.$apply()

    it "updates the data in the matching meal", ->
      expect(scope.meals[1].name).toEqual "Delicious Meal"

    it "does not update the data in other meals", ->
      expect(scope.meals[0].name).toEqual "Meal"

  describe "when a mealdeleted event is fired", ->
    beforeEach ->
      scope.meals = [{_id:'asdf', name: 'Meal'}, {_id:'qwer', name: 'Other Meal'}]
      scope.$broadcast "mealdeleted",
        _id: 'qwer'
        name: 'Other Meal'
      scope.$apply()

    it "deletes the meal from the collection", ->
      expect(scope.meals).toEqual [_id: 'asdf', name: 'Meal']

  describe "when a fileuploaddone event is fired", ->
    beforeEach ->
      Meals.all.reset()

      scope.$broadcast "fileuploaddone"
      scope.$apply()

    it "reloads the meals list", ->
      expect(Meals.all).toHaveBeenCalled()
