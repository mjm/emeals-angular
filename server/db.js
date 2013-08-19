var _ = require('underscore');
var cradle = require('cradle');
var db = new(cradle.Connection)({cache: false}).database('meals');

exports.allMeals = function (callback) {
  db.all({include_docs: true}, function(err, meals) {
    callback(err, _.pluck(meals, 'doc'));
  });
};

exports.getMeal = function (id, callback) {
  db.get(id, callback);
};

exports.updateMeal = function (meal, callback) {
  db.save(meal._id, meal._rev, _.omit(meal, '_id', '_rev'), callback);
};

exports.deleteMeal = function (id, rev, callback) {
  db.remove(id, rev, callback);
};
