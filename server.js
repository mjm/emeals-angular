var express = require('express');
var meals = require('./server/meals');
var http = require('http');
var path = require('path');

var app = express();

// all environments
app.set('port', process.env.PORT || 5000);
app.use(express.logger('dev'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);

app.get('/api/meals', meals.index);
app.get('/api/meals/:id', meals.show);
app.put('/api/meals/:id', meals.update);
app.delete('/api/meals/:id', meals.destroy);

// development only
if ('development' == app.get('env')) {
  app.use(express.static(path.join(__dirname, 'app')));
  app.use(express.static(path.join(__dirname, '.tmp')));
  app.use(express.errorHandler());
}

http.createServer(app).listen(app.get('port'), function(){
  console.log('Express server listening on port ' + app.get('port'));
});

