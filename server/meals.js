var db = require('./db');

exports.index = function(req, res) {
  db.allMeals(function(err, meals) {
    res.send(meals);
  });
};

exports.show = function(req, res) {
  db.getMeal(req.params.id, function (err, meal) {
    res.send(meal);
  });
};

exports.update = function(req, res) {
  db.updateMeal(req.body, function (err, result) {
    res.send(result);
  });
};

exports.destroy = function(req, res) {
  db.deleteMeal(req.params.id, req.query._rev, function (err, result) {
    res.send(result);
  });
};

exports.import = function(req, res) {
  db.importMenu(req.files.menu.path, function (err, result) {
    res.send(result);
  });
};
