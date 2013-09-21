angular.module('emeals.meals').directive 'preview', ->
  restrict: 'A'
  link: ($scope, elem, attrs) ->
    elem.popover
      selector: '.planning_meal'
      trigger: 'hover'
      html: true
      content: ->
        $(attrs.preview, this).html()
      container: 'body'
