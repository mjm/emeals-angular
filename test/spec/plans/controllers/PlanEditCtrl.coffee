describe "Controller: PlanEditCtrl", ->
  beforeEach module 'emeals.plans'
  beforeEach inject ($rootScope, $controller) ->
    @scope = $rootScope.$new()
    @plan =
      _id: "asdf"
      name: "An Existing Plan"
      days:
        start: "2013-08-05"
        end: "2013-08-09"
      meals: {}

    $controller 'PlanEditCtrl',
      $scope: @scope
      plan: @plan

  it "sets the provided plan", ->
    expect(@scope.plan).to.eql @plan

  it "marks the plan as not new", ->
    expect(@scope.isNew).to.be.false

  describe "when the user cancels editing the plan", ->
    beforeEach ->
      @scope.$apply => @scope.cancel()

    it "redirects to the plan's page", inject ($location) ->
      expect($location.path()).to.equal "/plans/asdf"

  describe "when the user tries to save the plan", ->
    beforeEach inject ($q) ->
      @putDeferred = $q.defer()
      @scope.plan.put = sinon.stub().returns @putDeferred.promise
      @scope.$apply => @scope.save()

    it "sends the new plan data to the server", ->
      expect(@scope.plan.put).to.have.been.called

    describe "when the save succeeds", ->
      beforeEach ->
        @scope.$apply => @putDeferred.resolve()

      it "redirects to the plan's page", inject ($location) ->
        expect($location.path()).to.equal "/plans/asdf"

    describe "when the save fails", ->
      beforeEach ->
        @scope.$apply =>
          @putDeferred.reject
            data:
              reason: "Document update conflict."

      it "displays an error message", ->
        expect(@scope.errors).to.eql [
          type: "error"
          message: "Document update conflict."
        ]
