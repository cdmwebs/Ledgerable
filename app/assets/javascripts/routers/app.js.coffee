class window.App extends Backbone.Router
  routes:
    '':            'home'
    'ledgers/:id': 'show',

  initialize: ->
    window.loadingView      = new LoadingView()
    window.ledgerListButton = new CrudButtonView({el: '#ledger_list_button'})
    Backbone.history.start({pushState: true})

  home: ->
    $(window.ledgerListButton.el).click()

  show: (ledger_id) ->
    $('table.ledger > tbody').empty()

    window.loadingView.toggle()

    window.ledger  = window.ledgers.get(ledger_id)
    window.entries = new Entries()

    window.entries.fetch({
      success: ->
        window.recurring_entries = new RecurringEntries()
        window.recurring_entries.fetch()

        window.rightNowView      = new RightNowView()
        window.ledgerView        = new LedgerShowView() if window.entries.length > 0
        window.graphsButton      = new CrudButtonView({el: '#graphs'})
        window.addEntryButton    = new CrudButtonView({el: '#add_entry'})
        window.editButton        = new CrudButtonView({el: '#edit'})
        window.deleteButton      = new CrudButtonView({el: '#delete'})
        window.recurringButton   = new CrudButtonView({el: '#recurring_entries'})
        window.searchButton      = new CrudButtonView({el: '#search'})

        window.entries.bind "remove", (entry) ->
          window.rightNowView.updateTotalAfterRemove(entry)

        window.loadingView.toggle()
    })

