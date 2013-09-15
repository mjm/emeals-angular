angular.module('emeals.controllers').controller 'ShoppingListCtrl', ($scope, plan, shoppingList) ->
  $scope.plan = plan
  $scope.shoppingList = shoppingList
