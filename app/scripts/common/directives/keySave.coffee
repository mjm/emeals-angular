angular.module('emeals.common').directive 'keySave', ($parse) ->
  restrict: 'A'
  link: ($scope, elem, attrs) ->
    fn = $parse(attrs.keySave)
    doSave = (e) ->
      e.preventDefault()
      $scope.$apply -> fn($scope)

    elem.bind 'keydown', 'meta+s', doSave
    elem.bind 'keydown', 'ctrl+s', doSave
