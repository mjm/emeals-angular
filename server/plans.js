var db = require('./db');

exports.current = function(req, res) {
  db.getCurrentPlan(function(err, plan) {
    if (err) {
      res.send(404, "");
    } else {
      res.send(200, plan);
    }
  });
};

exports.show = function(req, res) {
  db.getPlan(req.params.id, function(err, result) {
    res.send(result);
  });
};

exports.create = function(req, res) {
  db.createPlan(req.body, function(err, result) {
    res.send(result);
  });
}

exports.update = function(req, res) {
  db.updatePlan(req.body, function (err, result) {
    res.send(result);
  });
};
