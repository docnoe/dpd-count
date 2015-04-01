
Resource = require("deployd/lib/resource")
Collection = require "deployd/lib/resources/collection/"

createDomain = (data, errors) ->
  hasErrors = false
  domain =
    error: (key, val) ->
      errors[key] = val or true
      hasErrors = true
      return
    errorIf: (condition, key, value) ->
      domain.error key, value if condition
      return
    errorUnless: (condition, key, value) ->
      domain.errorIf not condition, key, value
      return
    hasErrors: ->
      hasErrors
    hide: (property) ->
      delete domain.data[property]
      return

    this: data
    data: data

  domain

class Collection extends Collection

Collection::count = (ctx, fn) ->
  done = (err, result) ->
    return fn(err)  if err
    return fn(null, result[0])  if typeof query.id is "string" and Array.isArray(result)
    fn null, result
    return

  collection = this
  query = ctx.query or {}
  errors = {}
  domain = createDomain(query, errors)

  goOn = (err, res) =>
    if err
      return fn(err)  if err
    store = @store
    sanitizedQuery = @sanitizeQuery(ctx.query or {})
    store.count sanitizedQuery, (err, result) ->
      return fn(err)  if err
      fn null,
          count: result

  if collection.shouldRunEvent(collection.events.Count, ctx)
    collection.events.Count.run ctx, domain, goOn
  else
    goOn()
  return

Collection.events.push "Count"

module.exports = Collection