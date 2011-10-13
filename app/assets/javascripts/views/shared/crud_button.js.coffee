class window.CrudButtonView extends Backbone.View
  events:
    'click': 'render'

  initialize: ->
    this.ledger_id = this.options.ledger_id
    this.enable()

  render: ->
    switch $(this.el).attr('id')
      when "edit"               then this.edit()
      when "add_entry"          then this.add()
      when "graphs"             then this.graphs()
      when "delete"             then this.delete()
      when "ledger_list_button" then this.ledgerListButton()
      when "recurring_entries"  then this.recurringEntries()
      when "search"             then this.search()

  enable: ->
    $(this.el).removeClass('disabled')

  graphs: ->
    $.colorbox({
      width:  700,
      height: 700,
      href:   "/ledgers/#{window.ledger.get('id')}/graphs",
    })

  edit: ->
    $.colorbox({
      href:       "/ledgers/#{window.ledger.get('id')}/edit",
      onClosed:   -> location.reload(true),
      onComplete: -> concentrate()
    }).resize()

  add: ->
    $.colorbox({
      href:       "/ledgers/#{window.ledger.get('id')}/entries/new",
      onClosed:   -> location.reload(true),
      onComplete: -> concentrate()
    }).resize()

  delete: ->
    if confirm "Are you really sure?"
      window.ledger.destroy()
      window.app.navigate('', true)

  ledgerListButton: ->
    if this.ledger_list is undefined
      this.ledger_list = new LedgerIndexView({parentElement: this})
    else
      this.ledger_list.remove()
      this.ledger_list = undefined

  recurringEntries: ->
    if this.recurring_list is undefined
      this.recurring_list = new RecurringEntryIndexView({parentElement: this})
    else
      this.recurring_list.remove()
      this.recurring_list = undefined

  search: ->
    if this.searchView is undefined
      this.searchView = new SearchView({parentElement: this})
    else
      this.searchView.remove()
      this.searchView = undefined
      window.ledger.clearSearchResults()

