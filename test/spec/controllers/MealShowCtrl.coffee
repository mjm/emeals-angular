describe "Controller: MealShowCtrl", ->

  MealShowCtrl = scope = meal = undefined

  beforeEach module('emeals')
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    meal =
      _id: "asdf"
      entree:
        name: "Entree 1"
      side:
        name: "Side 1"
    MealShowCtrl = $controller 'MealShowCtrl',
      $scope: scope
      meal: meal

  it "sets the current meal", ->
    expect(scope.meal).toEqual meal

  describe "deleting the meal", ->
    mealDeferred = oldLocation = undefined

    beforeEach inject ($q, $location, $window) ->
      mealDeferred = $q.defer()
      oldLocation = $location.path()

      meal.remove = jasmine.createSpy 'remove'
      meal.remove.andReturn mealDeferred.promise

      spyOn $window, 'confirm'

    it "attempts to confirm the removal", inject ($window) ->
      scope.remove()
      scope.$apply()
      expect($window.confirm).toHaveBeenCalled()

    describe "when the user rejects the deletion", ->
      beforeEach inject ($window) ->
        $window.confirm.andReturn false
        scope.remove()
        scope.$apply()

      it "does not call remove the meal", ->
        expect(meal.remove).not.toHaveBeenCalled()

    describe "when the user confirms the deletion", ->
      beforeEach inject ($window) ->
        $window.confirm.andReturn true
        scope.remove()
        scope.$apply()

      it "calls remove on the meal", ->
        expect(meal.remove).toHaveBeenCalled()

      it "does not change the location yet", inject ($location) ->
        expect($location.path()).toEqual oldLocation

      describe "when the delete goes through", ->
        deletedSpy = undefined

        beforeEach inject ($rootScope) ->
          deletedSpy = jasmine.createSpy "mealdeleted"
          $rootScope.$on "mealdeleted", deletedSpy

          mealDeferred.resolve()
          scope.$apply()

        it "redirects to the home page", inject ($location) ->
          expect($location.path()).toEqual "/"

        it "broadcasts a mealdeleted event", ->
          expect(deletedSpy).toHaveBeenCalled()
