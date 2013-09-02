var meals = require('./db/meals');
var errors = require('./errors');

exports.index = function(req, res) {
  meals.all(errors.handler(res));
};

exports.search = function(req, res) {
  meals.search(req.query.q, errors.handler(res));
};

exports.show = function(req, res) {
  meals.get(req.params.id, errors.handler(res));
};

exports.update = function(req, res) {
  meals.update(req.body, errors.handler(res));
};

exports.destroy = function(req, res) {
  meals.delete(req.params.id, req.query._rev, errors.handler(res));
};

exports.import = function(req, res) {
  meals.import(req.files.menu.path, function (err, result) {
    res.send(result);
  });
};
