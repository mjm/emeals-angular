var meals = require('./db/meals');

exports.index = function(req, res) {
  meals.all(function(err, meals) {
    res.send(meals);
  });
};

exports.show = function(req, res) {
  meals.get(req.params.id, function (err, meal) {
    res.send(meal);
  });
};

exports.update = function(req, res) {
  meals.update(req.body, function (err, result) {
    res.send(result);
  });
};

exports.destroy = function(req, res) {
  meals.delete(req.params.id, req.query._rev, function (err, result) {
    res.send(result);
  });
};

exports.import = function(req, res) {
  meals.import(req.files.menu.path, function (err, result) {
    res.send(result);
  });
};
