var _ = require('underscore');
var exec = require('child_process').exec;
var path = require('path');

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

function parserJarPath() {
  return path.join(__dirname, '..', '..', 'external', 'parser.jar');
}

function importCommandForMenu(menu) {
  return 'java -jar ' + parserJarPath() + ' ' + menu;
}

exports.import = function (menu, callback) {
  exec(importCommandForMenu(menu), function(err, stdout, stderr) {
    if (err) {
      callback(err, stderr);
    } else {
      var meals = JSON.parse(stdout);
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
    }
  });
};
