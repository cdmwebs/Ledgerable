class window.Entry extends Backbone.Model
  url: ->
    u = "/ledgers/#{this.get('ledger_id')}/entries"
    u += "/#{this.get('id')}" unless this.isNew()
    return u

  cleared: ->
    this.save({status: 'Cleared'})

  open: ->
    this.save({status: 'Open'})

  toJSON: ->
    {entry: this.attributes}

  editPath: ->
    "/ledgers/#{window.ledger.get('id')}/entries/#{this.get('id')}/edit"
