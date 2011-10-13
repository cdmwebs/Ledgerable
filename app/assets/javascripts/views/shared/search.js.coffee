class window.SearchView extends Backbone.View
  className: 'search_box'

  events:
    'keyup input': 'search',

  initialize: ->
    _.bindAll(this, 'remove', 'render', 'search')
    this.parentElement = this.options.parentElement
    this.render()

  render: ->
    _this = this
    $.get "/ledgers/search", (html) ->
      $(_this.el).html(html)
      $('body').append(_this.el)
      _this.position()
      _this.$('input').focus()

  position: ->
    $(this.el).position({
      my: 'center top',
      at: 'center bottom',
      of: $(this.parentElement.el),
      offset: '0 10'
    })

    this.$('.nib').position({
      my: 'center bottom',
      at: 'center top',
      of: $(this.el)
    })

  term: ->
    return this.$('input').val()

  remove: ->
    $(this.el).remove()

  search: (e) ->
    if e.keyCode is 27
      this.close()
    else
      window.ledgerView.clearSearchResults()

      if this.term().length > 2
        window.ledgerView.performSearch(this.term())
        this.updateResults()
      else
        this.clearResults()

  updateResults: ->
    this.clearResults()
    search = window.ledgerView.searchResults()
    resDiv = this.$('#results')

    this.$('#count').html("#{search.results.length} results")

    search.results.each (li) -> resDiv.append(li)

    resDiv.append("<li><strong>Total: $#{search.total.toFixed(2)}</strong></li>")

  clearResults: ->
    this.$('#results').empty()
    this.$('#count').empty()

  close: ->
    this.remove()
    window.ledgerView.clearSearchResults()

