var _ = require('underscore');

var meals = [
  {id: 1, entree: {name: "Entree 1"}, side: {name: "Side 1"}},
  {id: 2, entree: {name: "Entree 2"}, side: {name: "Side 2"}},
  {id: 3, entree: {name: "Entree 3"}, side: {name: "Side 3"}}
];

exports.index = function(req, res) {
  res.send(meals);
};

exports.show = function(req, res) {
  var meal = _.findWhere(meals, {id: parseInt(req.params.id)});
  res.send(meal);
};
