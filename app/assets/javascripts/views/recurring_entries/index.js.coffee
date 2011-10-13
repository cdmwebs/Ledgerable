class window.RecurringEntryIndexView extends Backbone.View
  className: 'recurring_entries_list'

  events:
    'click strong': 'delete',
    'click .plus':  'add'

  initialize: ->
    _.bindAll(this, 'remove', 'render')
    this.parentElement = this.options.parentElement
    this.render()

  render: ->
    _this = this
    $.get "/ledgers/#{window.ledger.get('id')}/recurring_entries", (html) ->
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

  add: ->
    $.colorbox({
      href:       "/ledgers/#{window.ledger.get('id')}/recurring_entries/new",
      onComplete: -> concentrate(),
      onClosed:   -> location.reload(true)
    }).resize()

  remove: ->
    $(this.el).remove()

  delete: (e) ->
    if confirm "Are you sure you want to delete this? All future entries will be deleted."
      id    = $(e.target).parent().attr('id')
      model = window.recurring_entries.get(id)
      model.destroy()
      location.reload()
