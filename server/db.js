var _ = require('underscore');
var cradle = require('cradle');
var http = require('http');
var fs = require('fs');
var dateFormat = require('dateformat');

var mealDb = new(cradle.Connection)({cache: false}).database('meals');
var planDb = new(cradle.Connection)({cache: false}).database('plans');

exports.allMeals = function (callback) {
  mealDb.all({include_docs: true}, function(err, meals) {
    callback(err, _.pluck(meals, 'doc'));
  });
};

exports.getMeal = function (id, callback) {
  mealDb.get(id, callback);
};

exports.updateMeal = function (meal, callback) {
  mealDb.save(meal._id, meal._rev, _.omit(meal, '_id', '_rev'), callback);
};

exports.deleteMeal = function (id, rev, callback) {
  mealDb.remove(id, rev, callback);
};

exports.importMenu = function (menu, callback) {
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
          mealDb.save(meal, function (err, res) {
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

function today() {
  return dateFormat('isoDate');
}

function daysLater(days) {
  var date = new Date();
  date.setDate(date.getDate() + days);
  return dateFormat(date, 'isoDate');
}

function createCurrentPlan(callback) {
  var plan = {
    name: "My Weekly Meal Plan",
    days: {
      start: today(),
      end: daysLater(6)
    },
    meals: {}
  };

  planDb.save(plan, function (err, res) {
    if (err) {
      callback(err, null);
    } else {
      plan._id = res.id;
      plan._rev = res.rev;
      callback(err, plan);
    }
  });
}

exports.getCurrentPlan = function(callback) {
  planDb.view('plans/current', {
    limit: 1,
    startkey: today(),
    include_docs: true
  }, function(err, results) {
    if (err) {
      callback(err, null);
    } else if (!results[0]) {
      createCurrentPlan(callback);
    } else {
      callback(err, results[0].doc);
    }
  });
};

exports.getPlan = function (id, callback) {
  planDb.get(id, callback);
};

exports.updatePlan = function(plan, callback) {
  planDb.save(plan._id, plan._rev, _.omit(plan, '_id', '_rev'), callback);
};
