var express = require('express');
var http = require('http');
var path = require('path');

var app = express();

// all environments
app.set('port', process.env.PORT || 5000);
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);

require('./server/routes')(app);

// development only
if ('development' == app.get('env')) {
  app.use(express.static(path.join(__dirname, 'app')));
  app.use(express.static(path.join(__dirname, '.tmp')));
  app.use(function(req, res, next) {
    res.sendfile(path.join(__dirname, 'app/index.html'));
  });
  app.use(express.errorHandler());
}

// production should have nginx serve static assets

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});

