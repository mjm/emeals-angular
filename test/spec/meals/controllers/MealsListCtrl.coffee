describe "Controller: MealsListCtrl", ->
  beforeEach module 'emeals.meals'
  beforeEach inject ($controller, $rootScope, $q) ->
    @mealsDeferred = $q.defer()
    @scope = $rootScope.$new()
    @meals = {search: sinon.stub().returns @mealsDeferred.promise}
    $controller 'MealsListCtrl',
      $scope: @scope
      $routeParams:
        mealId: "asdf"
      Meals: @meals

  it 'sets the meals', ->
    expect(@scope.meals).to.not.be.undefined

  it 'sets the route parameters', ->
    expect(@scope.$routeParams.mealId).to.eql "asdf"

  describe "when a mealupdated event is fired", ->
    beforeEach ->
      @scope.$apply => @mealsDeferred.resolve()

      @scope.meals = [{_id:'asdf', name: 'Meal'}, {_id:'qwer', name: 'Other Meal'}]
      @scope.$apply =>
        @scope.$broadcast "mealupdated",
          _id: 'qwer'
          name: 'Delicious Meal'

    it "updates the data in the matching meal", ->
      expect(@scope.meals[1].name).to.eql "Delicious Meal"

    it "does not update the data in other meals", ->
      expect(@scope.meals[0].name).to.eql "Meal"

  describe "when a mealdeleted event is fired", ->
    beforeEach ->
      @scope.$apply => @mealsDeferred.resolve()

      @scope.meals = [{_id:'asdf', name: 'Meal'}, {_id:'qwer', name: 'Other Meal'}]
      @scope.$apply =>
        @scope.$broadcast "mealdeleted",
          _id: 'qwer'
          name: 'Other Meal'

    it "deletes the meal from the collection", ->
      expect(@scope.meals).to.eql [_id: 'asdf', name: 'Meal']

  describe "when a fileuploaddone event is fired", ->
    beforeEach ->
      @meals.search.reset()
      @scope.$apply =>
        @scope.$broadcast "fileuploaddone",
          result:
            failures: [{}]
            successes: [{}] * 6

    it "reloads the meals list", ->
      expect(@meals.search).to.have.been.called

    describe "when no meals failed", ->
      beforeEach ->
        @scope.$apply =>
          @scope.$broadcast "fileuploaddone",
            result:
              failures: []
              successes: [{}, {}, {}]

      it "shows a success message", ->
        expect(@scope.errors).to.eql [
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
        expect(@scope.errors).to.eql [
          type: "warning"
          message: "2 meals imported. 1 failed to import."
        ]

  describe "when a fileuploadfail event is fired", ->
    beforeEach ->
      @scope.$apply => @scope.$broadcast "fileuploadfail"

    it "shows an error message", ->
      expect(@scope.errors).to.eql [
        type: "error"
        message: "An error occurred while importing. The error was logged."
      ]
