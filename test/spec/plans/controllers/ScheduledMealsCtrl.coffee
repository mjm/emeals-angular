describe "Controller: ScheduledMealsCtrl", ->
  beforeEach module 'emeals.plans'
  beforeEach inject ($rootScope, $controller) ->
    @scope = $rootScope.$new()
    $controller 'ScheduledMealsCtrl',
      $scope: @scope

  describe "when a plan is set", ->
    beforeEach ->
      @scope.$apply =>
        @scope.plan =
          days:
            start: "2013-08-05"
            end: "2013-08-09"
          meals:
            "2013-08-04": ["meal7", "meal8"]
            "2013-08-05": ["meal1", "meal2"]
            "2013-08-06": ["meal3", "meal4"]
            "2013-08-09": ["meal5", "meal6"]
            "2013-08-10": ["meal9", "meal10"]

    it "sets the meals by day", ->
      expect(@scope.mealsByDay).to.not.be.undefined

    it "sets the day range", ->
      expect(@scope.dayRange).to.eql [
        "2013-08-05"
        "2013-08-06"
        "2013-08-07"
        "2013-08-08"
        "2013-08-09"
      ]

    it "considers days outside the range hidden", ->
      expect(@scope.isDayHidden("2013-08-04")).to.be.true
      expect(@scope.isDayHidden("2013-08-05")).to.be.false
      expect(@scope.isDayHidden("2013-08-09")).to.be.false
      expect(@scope.isDayHidden("2013-08-10")).to.be.true

    describe "when the days change", ->
      beforeEach ->
        @scope.$apply =>
          @scope.plan.days.start = "2013-08-06"

      it "updates the day range", ->
        expect(@scope.dayRange).to.have.length 4

      it "considers days outside the new range hidden", ->
        expect(@scope.isDayHidden "2013-08-05").to.be.true

