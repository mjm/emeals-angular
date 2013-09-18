common = angular.module 'emeals.common', ['ngRoute', 'restangular']

common.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl "/api"
  RestangularProvider.setRestangularFields
    id: "_id"

_.mixin _.string.exports() # underscore string methods
