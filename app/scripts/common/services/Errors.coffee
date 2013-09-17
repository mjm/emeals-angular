angular.module('emeals.common').factory 'Errors', ($rootScope) ->
  Errors =
    setError: (message) ->
      Errors.setMessage 'error', message

    setWarning: (message) ->
      Errors.setMessage 'warning', message

    setSuccess: (message) ->
      Errors.setMessage 'success', message

    setMessage: (type, message) ->
      $rootScope.errors = [
        type: type
        message: message
      ]

    defaultHandler: (result) ->
      Errors.setError result?.data?.reason || "An error occurred."
