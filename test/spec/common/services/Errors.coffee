describe "Service: Errors", ->
  beforeEach module 'emeals.common'
  beforeEach inject (Errors) ->
    @subject = Errors

  it "can set an error message on the root scope", inject ($rootScope) ->
    @subject.setError "Some error."
    expect($rootScope.errors).to.eql [
      type: "error"
      message: "Some error."
    ]

  it "can set a warning message on the root scope", inject ($rootScope) ->
    @subject.setWarning "Some warning."
    expect($rootScope.errors).to.eql [
      type: "warning"
      message: "Some warning."
    ]

  it "can set a success message on the root scope", inject ($rootScope) ->
    @subject.setSuccess "Some success!"
    expect($rootScope.errors).to.eql [
      type: "success"
      message: "Some success!"
    ]

  it "clears the previous message when setting another", inject ($rootScope) ->
    @subject.setError "Some error."
    @subject.setWarning "Some warning."

    expect($rootScope.errors).to.eql [
      type: "warning"
      message: "Some warning."
    ]
