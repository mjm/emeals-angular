var cradle = require('cradle');
var dateFormat = require('dateformat');

var db = new(cradle.Connection)({cache: false}).database('plans');

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

  db.save(plan, function (err, res) {
    if (err) {
      callback(err, null);
    } else {
      plan._id = res.id;
      plan._rev = res.rev;
      callback(err, plan);
    }
  });
}

exports.getCurrent = function(callback) {
  db.view('plans/current', {
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

exports.get = function (id, callback) {
  db.get(id, callback);
};

exports.create = function(plan, callback) {
  db.save(plan, callback);
};

exports.update = function(plan, callback) {
  db.save(plan._id, plan._rev, _.omit(plan, '_id', '_rev'), callback);
};
