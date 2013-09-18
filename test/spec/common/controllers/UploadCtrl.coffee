describe 'Controller: UploadCtrl', ->
  beforeEach module 'emeals.common'
  beforeEach inject ($rootScope, $controller) ->
    @scope = $rootScope.$new()
    $controller 'UploadCtrl', $scope: @scope

  it "sets appropriate upload options", ->
    expect(@scope.options).to.not.be.undefined

  it "initially is not uploading", ->
    expect(@scope.isUploading).to.be.false

  describe "when a fileuploadstart event is triggered", ->
    beforeEach ->
      @scope.$apply =>
        @scope.$broadcast 'fileuploadstart'

    it "is now uploading", ->
      expect(@scope.isUploading).to.be.true

  describe "when a fileuploadalways event is triggered", ->
    beforeEach ->
      @scope.$apply =>
        @scope.isUploading = true
        @scope.$broadcast 'fileuploadalways'

    it "is no longer uploading", ->
      expect(@scope.isUploading).to.be.false
