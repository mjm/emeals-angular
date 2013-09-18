describe "Controller: PlanNewCtrl", ->
  beforeEach module 'emeals.plans'
  beforeEach inject ($rootScope, $controller, Dates) ->
    @scope = $rootScope.$new()
    sinon.stub(Dates, 'today').returns "2013-08-05"
    sinon.stub(Dates, 'daysLater').returns "2013-08-11"
    $controller 'PlanNewCtrl',
      $scope: @scope

  it "creates a new 7-day plan", ->
    expect(@scope.plan).to.eql
      name: ""
      days:
        start: "2013-08-05"
        end: "2013-08-11"
      meals: {}

  it "marks it as a new plan", ->
    expect(@scope.isNew).to.be.true

  describe "when the user cancels creating the plan", ->
    beforeEach ->
      @scope.$apply => @scope.cancel()

    it "redirects to the plans list", inject ($location) ->
      expect($location.path()).to.equal "/plans"

  describe "when the user saves the new plan", ->
    beforeEach ->
      @scope.plan.name = "My New Plan"

    afterEach inject ($httpBackend) ->
      $httpBackend.verifyNoOutstandingExpectation()

    it "attempts to save the plan", inject ($httpBackend) ->
      $httpBackend.expectPOST("/api/plans",
        name: "My New Plan"
        days:
          start: "2013-08-05"
          end: "2013-08-11"
        meals: {}
      ).respond ok: true, id: 'asdf'

      @scope.save()

    describe "and the save is successful", ->
      beforeEach inject ($httpBackend) ->
        $httpBackend.whenPOST("/api/plans").respond ok: true, id: "asdf"
        @scope.$apply => @scope.save()
        $httpBackend.flush()

      it "redirects to the page for the new plan", inject ($location) ->
        expect($location.path()).to.equal "/plans/asdf"

    describe "and the save fails", ->
      beforeEach inject ($httpBackend) ->
        $httpBackend.whenPOST("/api/plans").respond 409, error: "conflict", reason: "Document had conflict."
        @scope.$apply => @scope.save()
        $httpBackend.flush()

      it "displays an error message based on the response", ->
        expect(@scope.errors).to.eql [
          type: "error"
          message: "Document had conflict."
        ]
