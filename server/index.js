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

require('./routes')(app);

// development only
if ('development' == app.get('env')) {
  app.use(express.static(path.join(__dirname, '../_public')));
  app.use(function(req, res, next) {
    res.sendfile(path.join(__dirname, '../_public/index.html'));
  });
  app.use(express.errorHandler());
}

exports.startServer = function(port, path, callback) {
  http.createServer(app).listen(port, function(){
    console.log('Express server listening on port ' + port);
    callback();
  });
};
