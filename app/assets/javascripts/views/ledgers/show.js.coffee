class window.LedgerShowView extends Backbone.View
  el: 'table.ledger > tbody'

  initialize: ->
    _.bindAll(this, "render", "calcTotals")
    window.entries.bind("remove", this.calcTotals)
    window.entries.bind("add", this.calcTotals)

    window.entryViews  = []
    this.startingValue = window.ledger.get('todays_value')
    this.name          = window.ledger.get('name')

    this.render()
    this.calcTotals()
    this.centerFirstClearedEntry()

  render: ->
    $(this.el).empty()
    $('#ledger_name').html(this.name)

    _this = this
    window.entries.each (e) ->
      view = new EntryShowView({model: e})
      window.entryViews.push(view)
      $(_this.el).append(view.el)

  calcTotals: ->
    value = window.ledger.get('starting_value')

    window.entryViews.reverse().each (v) ->
      value += v.model.get('amount')
      $(v.el).find('.total').html(value.toFixed(2))
      $(v.el).addClass('negative_balance') if value < 0.0

  clearSearchResults: ->
    window.entryViews.each (v) ->
      v.clearSearchResult()

  performSearch: (term) ->
    regex = new RegExp(term, 'i')
    window.entryViews.each (v) ->
      v.performSearch(regex)

  searchResults: ->
    total   = 0.0
    results = []

    hits = _.select window.entryViews, (v) ->
      return v.isSearchHit()

    hits.each (v) ->
      date   = v.model.get('date')
      amount = v.model.get('amount')
      html   = "<li>$#{amount.format()} on #{date}</li>"
      total += amount
      results.push(html)

    return {results: results, total: total}

  centerFirstClearedEntry: ->
    target = $('#ledger')
    target.scrollTo(".cleared :first", {offset: (target.height() / 2) * -1})
