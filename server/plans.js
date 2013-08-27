var db = require('./db/plans');

exports.current = function(req, res) {
  db.getCurrent(function(err, plan) {
    if (err) {
      res.send(404, "");
    } else {
      res.send(200, plan);
    }
  });
};

exports.show = function(req, res) {
  db.get(req.params.id, function(err, result) {
    res.send(result);
  });
};

exports.create = function(req, res) {
  db.create(req.body, function(err, result) {
    res.send(result);
  });
}

exports.update = function(req, res) {
  db.update(req.body, function (err, result) {
    res.send(result);
  });
};
