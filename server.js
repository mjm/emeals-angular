var express = require('express');
var meals = require('./server/meals');
var plans = require('./server/plans');
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
app.post('/api/meals/import', meals.import);

app.post('/api/plans', plans.create);
app.get('/api/plans/past', plans.past);
app.get('/api/plans/current', plans.current);
app.get('/api/plans/:id', plans.show);
app.put('/api/plans/:id', plans.update);

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

