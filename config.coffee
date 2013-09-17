exports.config =
  conventions:
    assets: /^app\/assets\//
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  server:
    path: 'server/index.coffee'
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
          'app/scripts/common.coffee'
          'app/scripts/meals.coffee'
          'app/scripts/plans.coffee'
          'app/scripts/app.coffee'
        ]
    stylesheets:
      joinTo:
        'css/app.css': /^app/
        'css/vendor.css': /^bower_components/
  overrides:
    production:
      paths:
        public: 'dist'
