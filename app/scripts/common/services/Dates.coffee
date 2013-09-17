angular.module('emeals.common').factory 'Dates', ->
  Dates =
    format: (date) ->
      date.toJSON().slice(0, 10)

    toUTCDate: (date) ->
      localTime = date.getTime()
      localOffset = date.getTimezoneOffset() * 60000
      new Date(localTime - localOffset)

    today: ->
      Dates.format(Dates.toUTCDate(new Date()))

    daysLater: (days) ->
      date = Dates.toUTCDate(new Date())
      date.setDate(date.getDate() + days)
      Dates.format date
