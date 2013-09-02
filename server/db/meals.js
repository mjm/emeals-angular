var _ = require('underscore');
var exec = require('child_process').exec;
var path = require('path');

var cradle = require('cradle');
var db = new(cradle.Connection)({cache: false}).database('meals');

var ejs = require('elastic.js');
var NodeClient = require('elastic.js/elastic-node-client').NodeClient;

ejs.client = NodeClient('localhost', '9200');

exports.all = function (callback) {
  db.view('meals/by_entree_name', {
    include_docs: true
  }, function(err, results) {
    if (err) {
      callback(err, null);
    } else {
      callback(err, _.pluck(results, 'doc'));
    }
  });
};

exports.search = function (query, callback) {
  var query = ejs.MatchQuery("_all", query);
  var request = ejs.Request().indices("meals").types("meal").query(query);

  try {
    request.doSearch(function(results) {
      if (results.hits) {
        callback(null, _.pluck(results.hits.hits, '_source'));
      } else {
        callback({
          error: "not_found",
          message: "Search results could not be found."
        }, null);
      }
    });
  } catch (e) {
    callback({
      error: "internal_server_error",
      message: "The search backend had a problem."
    }, null);
  }
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
