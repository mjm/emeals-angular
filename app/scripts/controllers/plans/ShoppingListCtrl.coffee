categories =
  meat: "Meat and Seafood"
  null: "Miscellaneous"
  packaged: "Canned and Packaged"
  produce: "Produce"
  refrigerated: "Refrigerated"
  staple: "Staples"

angular.module('emeals.controllers').controller 'ShoppingListCtrl', ($scope, plan, shoppingList) ->
  $scope.plan = plan
  $scope.shoppingList = shoppingList.categories

  $scope.displayName = (category) -> categories[category]
