var _ = require('underscore');

var meals = [
  {id: 1, entree: {name: "Entree 1"}, side: {name: "Side 1"}},
  {id: 2, entree: {name: "Entree 2"}, side: {name: "Side 2"}},
  {id: 3, entree: {name: "Entree 3"}, side: {name: "Side 3"}}
];

function getMeal(id) {
  return _.findWhere(meals, {id: parseInt(id)});
}

exports.index = function(req, res) {
  res.send(meals);
};

exports.show = function(req, res) {
  var meal = getMeal(req.params.id);
  if (!meal) {
    res.send(404, { error: "Could not find meal with ID " + req.params.id });
    return;
  }
  res.send(meal);
};

exports.update = function(req, res) {
  var meal = req.body;
  _.extend(getMeal(req.params.id), meal);
  res.send(getMeal(req.params.id));
};
