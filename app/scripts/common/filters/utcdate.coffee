angular.module('emeals.common').filter 'utcdate', ($filter) ->
  (input, format='mediumDate') ->
    if typeof input is "string"
      localDate = new Date(input)
      localTime = localDate.getTime()
      localOffset = localDate.getTimezoneOffset() * 60000
      $filter('date')(new Date(localTime + localOffset), format)
    else
      $filter('date')(input, format)
