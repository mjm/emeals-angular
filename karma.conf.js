var karma = require('karma');
module.exports = function(config) {

  config.set({
    basePath: '',
    files: [
      'bower_components/angular/angular.js',
      'bower_components/angular-route/angular-route.js',
      'bower_components/angular-mocks/angular-mocks.js',
      'bower_components/lodash/lodash.js',
      'bower_components/underscore.string/lib/underscore.string.js',
      'bower_components/restangular/dist/restangular.js',
      'bower_components/jquery/jquery.js',
      'bower_components/jquery-file-upload/js/jquery.fileupload-angular.js',
      'app/scripts/app.coffee',
      'app/scripts/**/*.coffee',
      'test/spec/**/*.coffee'
    ],
    frameworks: ['mocha', 'sinon-chai'],
    exclude: [],
    reporters: ['dots', 'osx'],
    port: 8080,
    runnerPort: 9100,
    colors: true,
    logLevel: config.LOG_INFO,
    autoWatch: true,

    // Start these browsers, currently available:
    // - Chrome
    // - ChromeCanary
    // - Firefox
    // - Opera
    // - Safari (only Mac)
    // - PhantomJS
    // - IE (only Windows)
    browsers: ['PhantomJS'],

    // If browser does not capture in given timeout [ms], kill it
    captureTimeout: 10000,

    singleRun: false,

    preprocessors: {
      '**/*.coffee': ['coffee']
    }
  });
};

