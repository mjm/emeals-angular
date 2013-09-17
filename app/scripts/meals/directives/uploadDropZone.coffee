angular.module('emeals.meals').directive 'uploadDropZone', ->
  restrict: 'A'
  link: ($scope, elem) ->
    timeout = null
    $(document).bind 'dragover', (e) ->
      if !timeout
        elem.addClass 'in'
      else
        clearTimeout timeout

      found = false
      node = e.target
      while true
        if node is elem[0]
          found = true
          break
        node = node.parentNode
        break if node is null

      if found
        elem.addClass 'hover'
      else
        elem.removeClass 'hover'

      timeout = setTimeout ->
        timeout = null
        elem.removeClass 'in hover'
      , 100
