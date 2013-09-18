describe 'Controller: PlanShowCtrl', ->
  beforeEach module 'emeals.plans'
  beforeEach inject ($rootScope, $controller, $q, $httpBackend) ->
    $httpBackend.whenGET('views/meals/home.html').respond {} # ugh

    @scope = $rootScope.$new()
    @putDeferred = $q.defer()
    $controller 'PlanShowCtrl',
      $scope: @scope
      plan:
        _id: 'test-id'
        _rev: 'old-rev'
        name: 'Some Plan'
        days:
          start: '2013-08-19'
          end: '2013-08-23'
        meals:
          "2013-08-19": [{name: "Meal 1"}, {name: "Meal 2"}]
          "2013-08-21": [{name: "Meal 3"}, {name: "Meal 4"}]
          "2013-08-22": [{name: "Meal 5"}]
        put: sinon.stub().returns @putDeferred.promise
    @scope.$apply()

  it "groups the meals into rows of 3", ->
    expect(@scope.groupedMealsByDay["0"].length).to.equal 3
    expect(@scope.groupedMealsByDay["1"].length).to.equal 2

  it "includes the meals for each day", ->
    expect(@scope.groupedMealsByDay["0"][0].meals).to.eql [{name: "Meal 1"}, {name: "Meal 2"}]

  it "creates an empty list for any days that have no meals", ->
    expect(@scope.groupedMealsByDay["0"][1].meals).to.eql []
    expect(@scope.plan.meals["2013-08-20"]).to.eql []

  it "does not try to save the plan without changes", ->
    expect(@scope.plan.put).to.not.have.been.called

  describe "when a meal is added to a day", ->
    beforeEach ->
      @scope.$apply =>
        @scope.groupedMealsByDay["0"][1].meals.push name: "Meal 6"

    it "contains the new meal in the plan", ->
      expect(@scope.plan.meals["2013-08-20"]).to.eql [name: "Meal 6"]

    it "saves the plan", ->
      expect(@scope.plan.put).to.have.been.called

    describe "when saving the plan succeeds", ->
      beforeEach ->
        @scope.$apply =>
          @putDeferred.resolve
            ok: true
            rev: 'new-rev'

      it "updates the revision of the plan so future saves succeed", ->
        expect(@scope.plan._rev).to.eql "new-rev"

  describe "removing a meal from the plan", ->
    beforeEach ->
      @scope.$apply => @scope.remove "2013-08-19", 1

    it "removes the meal from the plan", ->
      expect(@scope.plan.meals["2013-08-19"]).to.eql [name: "Meal 1"]
      expect(@scope.groupedMealsByDay["0"][0].meals).to.eql [name: "Meal 1"]

    it "saves the plan", ->
      expect(@scope.plan.put).to.have.been.called

    describe "when saving the plan succeeds", ->
      beforeEach ->
        @scope.$apply =>
          @putDeferred.resolve
            ok: true
            rev: 'new-rev'

      it "updates the revision of the plan so future saves succeed", ->
        expect(@scope.plan._rev).to.eql "new-rev"
