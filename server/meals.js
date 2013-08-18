var _ = require('underscore');
var db = require('./db');

var meals = [
  {id: 1, entree: {name: "Entree 1"}, side: {name: "Side 1"}},
  {id: 2, entree: {name: "Entree 2"}, side: {name: "Side 2"}},
  {id: 3, entree: {name: "Entree 3"}, side: {name: "Side 3"}}
];

function getMeal(id) {
  return _.findWhere(meals, {id: parseInt(id)});
}

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
