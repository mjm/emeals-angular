services = angular.module 'emeals.services', ['restangular']

services.config (RestangularProvider) ->
  RestangularProvider.setBaseUrl "/api"
  RestangularProvider.setRestangularFields
    id: "_id"
