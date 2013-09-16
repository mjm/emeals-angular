_ = require 'underscore'
_s = require 'underscore.string'

categoryMap =
  pork: "meat"
  chicken: "meat"
  shrimp: "meat"
  bacon: "meat"
  cod: "meat"
  steak: "meat"
  scallop: "meat"
  walnut: "packaged"
  paste: "packaged"
  peach: "produce"
  lettuce: "produce"
  onion: "produce"
  arugula: "produce"
  zucchini: "produce"
  "jalapeño": "produce"
  spinach: "produce"
  mushroom: "produce"
  broccolini: "produce"
  carrot: "produce"
  radish: "produce"
  kale: "produce"
  egg: "refrigerated"
  cheese: "refrigerated"
  flour: "staple"
  meal: "staple"
  seasoning: "staple"
  cilantro: "staple"
  oil: "staple"
  garlic: "staple"
  cumin: "staple"
  oregano: "staple"
  salt: "staple"
  vinegar: "staple"
  rosemary: "staple"
  syrup: "staple"
  mayonnaise: "staple"
  paprika: "staple"
  powder: "staple"
  wine: "staple"
  pepper: (desc) ->
    if desc is "pepper" or /(black|red|ground|cayenne)/.test(desc)
      "staple"
    else
      "produce"
  lime: (desc) ->
    if _s.include(desc, "juice") then null else "produce"

exports.detect = (ingredient) ->
  words = _s.words(ingredient.description)
  for word in words
    category = categoryMap[word]
    if _.isFunction(category)
      return category(ingredient.description)
    return category if category
  null
