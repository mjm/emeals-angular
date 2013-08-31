describe "Controller: MealShowCtrl", ->
  beforeEach module('emeals.controllers')
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
    expect(@scope.meal).toEqual @meal

  describe "deleting the meal", ->
    beforeEach inject ($q, $location, $window) ->
      @mealDeferred = $q.defer()
      @oldLocation = $location.path()

      @meal.remove = jasmine.createSpy('remove').andReturn @mealDeferred.promise
      spyOn $window, 'confirm'

    it "attempts to confirm the removal", inject ($window) ->
      @scope.$apply => @scope.remove()
      expect($window.confirm).toHaveBeenCalled()

    describe "when the user rejects the deletion", ->
      beforeEach inject ($window) ->
        $window.confirm.andReturn false
        @scope.$apply => @scope.remove()

      it "does not call remove the meal", ->
        expect(@meal.remove).not.toHaveBeenCalled()

    describe "when the user confirms the deletion", ->
      beforeEach inject ($window) ->
        $window.confirm.andReturn true
        @scope.$apply => @scope.remove()

      it "calls remove on the meal", ->
        expect(@meal.remove).toHaveBeenCalled()

      it "does not change the location yet", inject ($location) ->
        expect($location.path()).toEqual @oldLocation

      describe "when the delete goes through", ->
        beforeEach inject ($rootScope) ->
          @deletedSpy = jasmine.createSpy "mealdeleted"
          $rootScope.$on "mealdeleted", @deletedSpy

          @scope.$apply => @mealDeferred.resolve()

        it "redirects to the home page", inject ($location) ->
          expect($location.path()).toEqual "/"

        it "broadcasts a mealdeleted event", ->
          expect(@deletedSpy).toHaveBeenCalled()
