angular.module('emeals.directives').directive 'draggable', ($location, Navigation) ->
  restrict: 'A'
  link: ($scope, elem, attrs) ->
    elem.draggable
      helper: "clone"
      appendTo: "body"
      revert: true

    $scope.$watch (-> $location.path() ), ->
      elem.draggable "option", "disabled", !Navigation.isViewingPlans()
