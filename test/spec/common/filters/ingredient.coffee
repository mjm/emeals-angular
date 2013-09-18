describe "Filter: ingredient", ->
  beforeEach module 'emeals.common'
  beforeEach inject ($filter) ->
    @ingredient = $filter('ingredient')

  it "displays correctly when all fields are present", ->
    ing =
      amount: '1/2'
      unit: 'teaspoon'
      description: 'kosher salt'
    expect(@ingredient(ing)).to.equal '1/2 teaspoon kosher salt'

  it "displays correctly when unit is absent", ->
    ing =
      amount: '4'
      unit: null
      description: 'large eggs'
    expect(@ingredient(ing)).to.equal '4 large eggs'

  it "displays correctly when both amount and unit are absent", ->
    ing =
      amount: null
      unit: null
      description: 'Zest and juice of 1 lemon'
    expect(@ingredient(ing)).to.equal 'Zest and juice of 1 lemon'
