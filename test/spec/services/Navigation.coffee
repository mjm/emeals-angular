describe 'Service: Navigation', ->
  beforeEach module 'emeals.services'
  beforeEach inject (Navigation) ->
    @nav = Navigation

  describe "current location", ->
    it "considers / a meals location", inject ($location) ->
      $location.path "/"
      expect(@nav.isViewingMeals()).toBe true
      expect(@nav.isViewingPlans()).toBe false

    it "considers /meals/:id a meals location", inject ($location) ->
      $location.path "/meals/some-id"
      expect(@nav.isViewingMeals()).toBe true
      expect(@nav.isViewingPlans()).toBe false

    it "considers /plans/current a plans location", inject ($location) ->
      $location.path "/plans/current"
      expect(@nav.isViewingMeals()).toBe false
      expect(@nav.isViewingPlans()).toBe true
