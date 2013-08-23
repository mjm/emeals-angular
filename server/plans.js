var db = require('./db');

exports.current = function(req, res) {
  db.getCurrentPlan(function(err, plan) {
    res.send(plan);
  });
}
