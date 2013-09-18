describe 'Service: Navigation', ->
  beforeEach module 'emeals.common'
  beforeEach inject (Navigation) ->
    @nav = Navigation

  describe "current location", ->
    it "considers / a meals location", inject ($location) ->
      $location.path "/"
      expect(@nav.isViewingMeals()).to.be.true
      expect(@nav.isViewingPlans()).to.be.false

    it "considers /meals/:id a meals location", inject ($location) ->
      $location.path "/meals/some-id"
      expect(@nav.isViewingMeals()).to.be.true
      expect(@nav.isViewingPlans()).to.be.false

    it "considers /plans/current a plans location", inject ($location) ->
      $location.path "/plans/current"
      expect(@nav.isViewingMeals()).to.be.false
      expect(@nav.isViewingPlans()).to.be.true
