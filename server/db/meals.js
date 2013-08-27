var _ = require('underscore');
var http = require('http');
var fs = require('fs');

var cradle = require('cradle');
var db = new(cradle.Connection)({cache: false}).database('meals');

exports.all = function (callback) {
  db.all({include_docs: true}, function(err, meals) {
    callback(err, _.pluck(meals, 'doc'));
  });
};

exports.get = function (id, callback) {
  db.get(id, callback);
};

exports.update = function (meal, callback) {
  db.save(meal._id, meal._rev, _.omit(meal, '_id', '_rev'), callback);
};

exports.delete = function (id, rev, callback) {
  db.remove(id, rev, callback);
};

exports.import = function (menu, callback) {
  var req = http.request({
    host: "localhost",
    port: 4567,
    path: "/import",
    method: "POST",
    headers: {
      'Content-type': 'application/pdf'
    }
  }, function (res) {
    res.on('data', function(data) {
      var meals = JSON.parse(data);
      var results = [];
      function process(meal) {
        if (meal) {
          db.save(meal, function (err, res) {
            results.push(res);
            process(meals.shift());
          });
        } else {
          callback(null, results);
        }
      }
      process(meals.shift());
    });
  });

  req.on('error', function (err) {
    callback(err, null);
  });

  fs.readFile(menu, function (err, data) {
    req.write(data);
    req.end();
  });
};
