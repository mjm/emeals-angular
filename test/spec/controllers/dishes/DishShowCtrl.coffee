describe "Controller: DishShowCtrl", ->
  DishShowCtrl = scope = undefined

  beforeEach module('emeals.controllers')

  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    DishShowCtrl = $controller 'DishShowCtrl',
      $scope: scope

  it "has no dish set", ->
    expect(scope.dish).toBeUndefined()

  describe "when a meal is set in the scope", ->
    beforeEach ->
      scope.type = "entree"
      scope.meal =
        _id: "asdf"
        entree:
          name: "My Entree"
          ingredients: [amount: "1", unit: "teaspoon", description: "kosher salt"]
      scope.$apply()

    it "sets the dish", ->
      expect(scope.dish).toEqual
        name: "My Entree"
        ingredients: [amount: "1", unit: "teaspoon", description: "kosher salt"]

