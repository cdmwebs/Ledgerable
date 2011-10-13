class window.LedgerIndexView extends Backbone.View
  className: 'ledger_list'

  events:
    'click tr':    'goToLedger',
    'click .plus': 'add'

  initialize: ->
    _.bindAll(this, 'remove', 'render')
    this.parentElement = this.options.parentElement
    this.render()

  render: ->
    _this = this
    $.get "/ledgers", (html) ->
      $(_this.el).html(html)
      $('body').append(_this.el)
      _this.position()

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

  remove: ->
    $(this.el).remove()

  goToLedger: (e) ->
    $(this.parentElement.el).click()
    ledger_id = $(e.target).parent().attr('id')
    window.app.navigate("ledgers/#{ledger_id}", true)

  add: ->
    $.colorbox({
      href:       "/ledgers/new",
      onComplete: -> concentrate(),
      onClosed:   -> location.reload(true)
    }).resize()
