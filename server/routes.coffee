meals = require './meals'
plans = require './plans'

module.exports = (app) ->
  app.get    '/api/meals',         meals.index
  app.get    '/api/meals/search',  meals.search
  app.get    '/api/meals/:id',     meals.show
  app.put    '/api/meals/:id',     meals.update
  app.delete '/api/meals/:id',     meals.destroy
  app.post   '/api/meals/import',  meals.import

  app.post   '/api/plans',         plans.create
  app.get    '/api/plans/past',    plans.past
  app.get    '/api/plans/future',  plans.future
  app.get    '/api/plans/current', plans.current
  app.get    '/api/plans/:id',     plans.show
  app.put    '/api/plans/:id',     plans.update
  app.delete '/api/plans/:id',     plans.destroy
  app.get    '/api/plans/:id/shopping_list', plans.shoppingList
