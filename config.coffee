exports.config =
  conventions:
    assets: /^app\/assets\//
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  server:
    path: 'server/index.js'
  files:
    javascripts:
      joinTo:
        'js/vendor.js': /^bower_components/
        'js/app.js': /^app/
      order:
        before: [
          'bower_components/lodash/lodash.js'
          'bower_components/jquery/jquery.js'
          'bower_components/angular/angular.js'
          'app/scripts/app.coffee'
          'app/scripts/services/services.coffee'
          'app/scripts/filters/filters.coffee'
          'app/scripts/directives/directives.coffee'
          'app/scripts/controllers/controllers.coffee'
        ]
    stylesheets:
      joinTo:
        'css/app.css': /^(app|vendor|bower_components)/
  overrides:
    production:
      paths:
        public: 'dist'
