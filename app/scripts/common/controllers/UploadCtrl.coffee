angular.module('emeals.common').controller 'UploadCtrl', ($scope) ->
  $scope.options =
    autoUpload: true
    dropZone: $("#sidebar")

  $scope.isUploading = false

  $scope.$on 'fileuploadalways', ->
    $scope.isUploading = false

  $scope.$on 'fileuploadstart', ->
    $scope.isUploading = true
