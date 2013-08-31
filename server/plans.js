var db = require('./db/plans');
var errors = require('./errors');

exports.current = function(req, res) {
  db.getCurrent(errors.handler(res));
};

exports.past = function(req, res) {
  db.allPast(errors.handler(res));
};

exports.future = function(req, res) {
  db.allFuture(errors.handler(res));
};

exports.show = function(req, res) {
  db.get(req.params.id, errors.handler(res));
};

exports.create = function(req, res) {
  db.create(req.body, errors.handler(res));
}

exports.update = function(req, res) {
  db.update(req.body, errors.handler(res));
};
