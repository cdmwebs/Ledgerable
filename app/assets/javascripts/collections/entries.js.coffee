class window.Entries extends Backbone.Collection
  model: window.Entry

  url: ->
    return "/ledgers/#{window.ledger.get('id')}/entries"
