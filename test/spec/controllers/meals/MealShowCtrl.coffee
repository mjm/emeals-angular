describe "Controller: MealShowCtrl", ->
  beforeEach module 'emeals.meals'
  beforeEach inject ($controller, $rootScope) ->
    @scope = $rootScope.$new()
    @meal =
      _id: "asdf"
      entree:
        name: "Entree 1"
      side:
        name: "Side 1"
    $controller 'MealShowCtrl',
      $scope: @scope
      meal: @meal

  it "sets the current meal", ->
    expect(@scope.meal).to.eql @meal

  describe "deleting the meal", ->
    beforeEach inject ($q, $location, $window) ->
      @mealDeferred = $q.defer()
      @oldLocation = $location.path()

      @meal.remove = sinon.stub().returns @mealDeferred.promise
      @sandbox = sinon.sandbox.create()
      @sandbox.stub $window, 'confirm'

    afterEach ->
      @sandbox.restore()

    it "attempts to confirm the removal", inject ($window) ->
      @scope.$apply => @scope.remove()
      expect($window.confirm).to.have.been.called

    describe "when the user rejects the deletion", ->
      beforeEach inject ($window) ->
        $window.confirm.returns false
        @scope.$apply => @scope.remove()

      it "does not call remove the meal", ->
        expect(@meal.remove).to.not.have.been.called

    describe "when the user confirms the deletion", ->
      beforeEach inject ($window) ->
        $window.confirm.returns true
        @scope.$apply => @scope.remove()

      it "calls remove on the meal", ->
        expect(@meal.remove).to.have.been.called

      it "does not change the location yet", inject ($location) ->
        expect($location.path()).to.eql @oldLocation

      describe "when the delete goes through", ->
        beforeEach inject ($rootScope) ->
          @deletedSpy = sinon.spy()
          $rootScope.$on "mealdeleted", @deletedSpy

          @scope.$apply => @mealDeferred.resolve()

        it "redirects to the home page", inject ($location) ->
          expect($location.path()).to.eql "/"

        it "broadcasts a mealdeleted event", ->
          expect(@deletedSpy).to.have.been.called
