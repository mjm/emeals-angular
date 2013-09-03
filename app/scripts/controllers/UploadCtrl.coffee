angular.module('emeals.controllers').controller 'UploadCtrl', ($scope) ->
  $scope.options =
    autoUpload: true
    dropZone: $("#sidebar")

  $scope.isUploading = false

  $scope.$on 'fileuploaddone', ->
    $scope.isUploading = false

  $scope.$on 'fileuploadstart', ->
    $scope.isUploading = true
