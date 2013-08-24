angular.module('emeals').directive 'draggable', ->
  restrict: 'A'
  link: ($scope, elem, attrs) ->
    elem.draggable
      helper: "clone"
      appendTo: "body"
      revert: true
