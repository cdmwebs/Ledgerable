class window.RecurringEntries extends Backbone.Collection
  model: window.RecurringEntry

  url: ->
    return "/ledgers/#{window.ledger.get('id')}/recurring_entries"
