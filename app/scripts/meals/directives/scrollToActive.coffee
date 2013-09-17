angular.module('emeals.meals').directive 'scrollToActive', ($timeout) ->
  isVisible = (elem, container) ->
    viewport =
      top: 0
      bottom: container.height()

    element =
      top: elem.offset().top
      bottom: elem.offset().top + elem.height()

    element.bottom <= viewport.bottom and element.top >= viewport.top

  scrollToElement = (elem, container) ->
    windowTop = container.scrollTop()
    elemTop = elem.offset().top

    if elemTop < 0
      # element is above viewport, scroll it so it is near the top
      elemTop += windowTop - 70;
    else
      # element is below viewport, so we want to scroll so it is just visible
      # from the bottom
      elemTop += windowTop - container.height() + elem.height() - 20;

    container.animate
      scrollTop: elemTop

  restrict: 'A'
  link: ($scope, elem, attrs) ->
    container = $(attrs.scrollContainer)

    scrollIfPossible = (id) ->
      activeElem = elem.find("[data-id=#{id}]")
      if activeElem.length > 0 && !isVisible(activeElem, container)
        scrollToElement activeElem, container

    $scope.$watch attrs.scrollToActive, scrollIfPossible

    $timeout ->
      scrollIfPossible $scope.$eval(attrs.scrollToActive)
    , 100
