describe 'Controller: PlanShowCtrl', ->
  plan = scope = undefined

  beforeEach module 'emeals'
  beforeEach inject ($rootScope, $controller) ->
    scope = $rootScope.$new()
    $controller 'PlanShowCtrl',
      $scope: scope
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
        put: jasmine.createSpy "put"
    scope.$apply()

  it "groups the meals into rows of 3", ->
    expect(scope.groupedMealsByDay["0"].length).toEqual 3
    expect(scope.groupedMealsByDay["1"].length).toEqual 2

  it "includes the meals for each day", ->
    expect(scope.groupedMealsByDay["0"][0].meals).toEqual [{name: "Meal 1"}, {name: "Meal 2"}]

  it "creates an empty list for any days that have no meals", ->
    expect(scope.groupedMealsByDay["0"][1].meals).toEqual []
    expect(scope.plan.meals["2013-08-20"]).toEqual []

  it "does not try to save the plan without changes", ->
    expect(scope.plan.put).not.toHaveBeenCalled()

  describe "when a meal is added to a day", ->
    putDeferred = undefined
    beforeEach inject ($q) ->
      putDeferred = $q.defer()
      scope.plan.put.andReturn putDeferred.promise
      scope.$apply ->
        scope.groupedMealsByDay["0"][1].meals.push name: "Meal 6"

    it "contains the new meal in the plan", ->
      expect(scope.plan.meals["2013-08-20"]).toEqual [name: "Meal 6"]

    it "saves the plan", inject ($httpBackend) ->
      expect(scope.plan.put).toHaveBeenCalled()

    describe "when saving the plan succeeds", ->
      beforeEach ->
        putDeferred.resolve
          ok: true
          rev: 'new-rev'

        scope.$apply()

      it "updates the revision of the plan so future saves succeed", ->
        expect(scope.plan._rev).toEqual "new-rev"
