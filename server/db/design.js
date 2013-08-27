var plansDesign = {
  "_id": "_design/plans",
  "views": {
    "current": {
      "map": "function(doc) { emit(doc.days.end, null); }"
    }
  }
};

var cradle = require('cradle');
var planDb = new(cradle.Connection)({cache: false}).database('plans');

exports.importPlansDesign = function() {
  planDb.save(plansDesign._id, plansDesign, function (err, res) {
    if (err) {
      console.error("An error occurred trying to import plans design");
      console.error(err);
    } else {
      console.log("Successfully imported plans design!");
    }
  });
};
