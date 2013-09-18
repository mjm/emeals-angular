describe "Controller: MealEditCtrl", ->
  beforeEach module 'emeals.meals'
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
    expect(@scope.meal).to.eql @meal

  describe "cancelling edits", ->
    beforeEach ->
      @meal.put = sinon.spy()
      @scope.cancel()

    it "does not save the meal", ->
      expect(@meal.put).to.not.have.been.called

    it "navigates to the meal show page", inject ($location) ->
      expect($location.path()).to.eql "/meals/asdf"

  describe "saving edits", ->
    beforeEach inject ($q, $location) ->
      @mealDeferred = $q.defer()
      @originalPath = $location.path()

      @meal.put = sinon.stub().returns(@mealDeferred.promise)
      @scope.save()

    it "saves the meal", ->
      expect(@meal.put).to.have.been.called

    it "does not yet navigate to the meal show page", inject ($location) ->
      expect($location.path()).to.eql @originalPath

    describe "and the meal is successfully saved", ->
      beforeEach inject ($rootScope) ->
        @mealUpdatedSpy = sinon.spy()
        $rootScope.$new().$on "mealupdated", @mealUpdatedSpy

        @scope.$apply => @mealDeferred.resolve()

      it "broadcasts a mealupdated event", ->
        expect(@mealUpdatedSpy).to.have.been.called

      it "navigates to the meal show page", inject ($location) ->
        expect($location.path()).to.eql "/meals/asdf"
