var plansDesign = {
  "_id": "_design/plans",
  "views": {
    "current": {
      "map": "function(doc) { emit(doc.days.end, null); }"
    }
  }
};

var mealsDesign = {
  "_id": "_design/meals",
  "views": {
    "by_entree_name": {
      "map": "function(doc) { emit(doc.entree.name, null); }"
    }
  }
};

var cradle = require('cradle');
var mealDb = new(cradle.Connection)({cache: false}).database('meals');
var planDb = new(cradle.Connection)({cache: false}).database('plans');

function importDesignIntoDb(doc, db) {
  db.save(doc._id, doc, function (err, res) {
    if (err) {
      console.error("An error occurred trying to import design '" + doc._id + "'.");
      console.error(err);
    } else {
      console.log("Successfully imported design '" + doc._id + "'.");
    }
  });
}

exports.importPlansDesign = function() {
  importDesignIntoDb(plansDesign, planDb);
};

exports.importMealsDesign = function() {
  importDesignIntoDb(mealsDesign, mealDb);
};

exports.importAll = function() {
  exports.importMealsDesign();
  exports.importPlansDesign();
}
