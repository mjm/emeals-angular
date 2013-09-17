getModelValue = (elem) ->
  elem.scope().$eval(elem.attr 'ng-model') if elem.attr 'ng-model'

angular.module('emeals.common').directive 'droppable', ->
  restrict: 'A'
  link: ($scope, elem, attrs) ->
    elem.droppable
      hoverClass: "panel-success"
      drop: (event, ui) ->
        droppedValue = getModelValue elem
        draggedValue = getModelValue ui.draggable
        if droppedValue and draggedValue
          unless _.contains(_.pluck(droppedValue, '_id'), draggedValue._id)
            unless attrs.droppableLimit and droppedValue.length >= attrs.droppableLimit
              $scope.$apply -> droppedValue.push(draggedValue)
