var db = require('./db');

exports.current = function(req, res) {
  db.getCurrentPlan(function(err, plan) {
    if (err) {
      res.send(404, "");
    } else {
      res.send(200, plan);
    }
  });
}
