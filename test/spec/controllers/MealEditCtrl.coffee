describe "Controller: MealEditCtrl", ->

  MealEditCtrl = scope = meal = undefined

  beforeEach module('emeals')
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    meal =
      id: 1
      entree:
        name: "Entree 1"
      side:
        name: "Side 1"
    MealEditCtrl = $controller 'MealEditCtrl',
      $scope: scope
      meal: meal

  it "sets the current meal", ->
    expect(scope.meal).toEqual meal

