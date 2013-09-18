describe "Controller: ShoppingListCtrl", ->
  beforeEach module 'emeals.plans'
  beforeEach inject ($rootScope, $controller) ->
    @scope = $rootScope.$new()

    $controller 'ShoppingListCtrl',
      $scope: @scope
      plan:
        name: "whatever"
      shoppingList:
        categories:
          meat: []
          produce: []

  it "sets the plan", ->
    expect(@scope.plan.name).to.equal "whatever"

  it "sets the shopping list data", ->
    expect(@scope.shoppingList).to.eql
      meat: []
      produce: []
