describe "Controller: DishEditCtrl", ->
  beforeEach module('emeals.controllers')
  beforeEach inject ($controller, $rootScope) ->
    @scope = $rootScope.$new()
    $controller 'DishEditCtrl',
      $scope: @scope

  it "has no dish set", ->
    expect(@scope.dish).toBeUndefined()

  it "sets unit choices", ->
    expect(@scope.unitChoices).not.toBeUndefined()

  describe "when a meal is set in the scope", ->
    beforeEach ->
      @scope.type = "entree"
      @scope.meal =
        _id: "asdf"
        entree:
          name: "My Entree"
          ingredients: [amount: "1", unit: "teaspoon", description: "kosher salt"]
      @scope.$apply()

    it "sets the dish", ->
      expect(@scope.dish).toEqual
        name: "My Entree"
        ingredients: [amount: "1", unit: "teaspoon", description: "kosher salt"]

    describe "removing an ingredient", ->
      beforeEach -> @scope.remove(0)

      it "deletes the ingredient from the list", ->
        expect(@scope.dish.ingredients).toEqual []

    describe "adding an ingredient", ->
      describe "when an ingredients list already exists", ->
        beforeEach -> @scope.add()

        it "adds a blank ingredient to the end of the list", ->
          expect(@scope.dish.ingredients.length).toEqual 2
          expect(@scope.dish.ingredients[1]).toEqual
            amount: ""
            unit: ""
            description: ""

      describe "when there is no ingredients list", ->
        beforeEach ->
          delete @scope.dish.ingredients
          @scope.add()

        it "adds a blank ingredient to a new list", ->
          expect(@scope.dish.ingredients).toEqual [amount: "", unit: "", description: ""]

