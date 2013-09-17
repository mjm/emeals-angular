describe "Controller: MealsListCtrl", ->
  beforeEach module('emeals.meals')
  beforeEach inject ($controller, $rootScope, $q) ->
    @mealsDeferred = $q.defer()
    @scope = $rootScope.$new()
    @meals = {search: jasmine.createSpy("Meals").andReturn @mealsDeferred.promise}
    $controller 'MealsListCtrl',
      $scope: @scope
      $routeParams:
        mealId: "asdf"
      Meals: @meals

  it 'sets the meals', ->
    expect(@scope.meals).not.toBeUndefined()

  it 'sets the route parameters', ->
    expect(@scope.$routeParams.mealId).toEqual "asdf"

  describe "when a mealupdated event is fired", ->
    beforeEach ->
      @scope.$apply =>
        @mealsDeferred.resolve()

      @scope.meals = [{_id:'asdf', name: 'Meal'}, {_id:'qwer', name: 'Other Meal'}]
      @scope.$apply =>
        @scope.$broadcast "mealupdated",
          _id: 'qwer'
          name: 'Delicious Meal'

    it "updates the data in the matching meal", ->
      expect(@scope.meals[1].name).toEqual "Delicious Meal"

    it "does not update the data in other meals", ->
      expect(@scope.meals[0].name).toEqual "Meal"

  describe "when a mealdeleted event is fired", ->
    beforeEach ->
      @scope.$apply =>
        @mealsDeferred.resolve()

      @scope.meals = [{_id:'asdf', name: 'Meal'}, {_id:'qwer', name: 'Other Meal'}]
      @scope.$apply =>
        @scope.$broadcast "mealdeleted",
          _id: 'qwer'
          name: 'Other Meal'

    it "deletes the meal from the collection", ->
      expect(@scope.meals).toEqual [_id: 'asdf', name: 'Meal']

  describe "when a fileuploaddone event is fired", ->
    beforeEach ->
      @meals.search.reset()
      @scope.$apply =>
        @scope.$broadcast "fileuploaddone",
          result:
            failures: [{}]
            successes: [{}] * 6

    it "reloads the meals list", ->
      expect(@meals.search).toHaveBeenCalled()

    describe "when no meals failed", ->
      beforeEach ->
        @scope.$apply =>
          @scope.$broadcast "fileuploaddone",
            result:
              failures: []
              successes: [{}, {}, {}]

      it "shows a success message", ->
        expect(@scope.errors).toEqual [
          type: "success"
          message: "3 meals imported."
        ]

    describe "when some meals failed", ->
      beforeEach ->
        @scope.$apply =>
          @scope.$broadcast "fileuploaddone",
            result:
              failures: [{}]
              successes: [{}, {}]

      it "shows a warning message", ->
        expect(@scope.errors).toEqual [
          type: "warning"
          message: "2 meals imported. 1 failed to import."
        ]

  describe "when a fileuploadfail event is fired", ->
    beforeEach ->
      @scope.$apply =>
        @scope.$broadcast "fileuploadfail"

    it "shows an error message", ->
      expect(@scope.errors).toEqual [
        type: "error"
        message: "An error occurred while importing. The error was logged."
      ]
