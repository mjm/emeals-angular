describe "Controller: MealEditCtrl", ->
  beforeEach module('emeals.controllers')
  beforeEach inject ($controller, $rootScope) ->
    @scope = $rootScope.$new()
    @meal =
      _id: "asdf"
      entree:
        name: "Entree 1"
      side:
        name: "Side 1"

    $controller 'MealEditCtrl',
      $scope: @scope
      meal: @meal

  it "sets the current meal", ->
    expect(@scope.meal).toEqual @meal

  describe "cancelling edits", ->
    beforeEach ->
      @meal.put = jasmine.createSpy('put')
      @scope.cancel()

    it "does not save the meal", ->
      expect(@meal.put).not.toHaveBeenCalled()

    it "navigates to the meal show page", inject ($location) ->
      expect($location.path()).toEqual "/meals/asdf"

  describe "saving edits", ->
    beforeEach inject ($q, $location) ->
      @mealDeferred = $q.defer()
      @originalPath = $location.path()

      @meal.put = jasmine.createSpy('put').andReturn(@mealDeferred.promise)
      @scope.save()

    it "saves the meal", ->
      expect(@meal.put).toHaveBeenCalled()

    it "does not yet navigate to the meal show page", inject ($location) ->
      expect($location.path()).toEqual @originalPath

    describe "and the meal is successfully saved", ->
      beforeEach inject ($rootScope) ->
        @mealUpdatedSpy = jasmine.createSpy('mealupdated')
        $rootScope.$new().$on "mealupdated", @mealUpdatedSpy

        @scope.$apply => @mealDeferred.resolve()

      it "broadcasts a mealupdated event", ->
        expect(@mealUpdatedSpy).toHaveBeenCalled()

      it "navigates to the meal show page", inject ($location) ->
        expect($location.path()).toEqual "/meals/asdf"
