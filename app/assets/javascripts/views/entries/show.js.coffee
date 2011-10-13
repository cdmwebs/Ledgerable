class window.EntryShowView extends Backbone.View
  tagName: 'tr'
  className: 'entry'
  events:
    "click": "showControls"

  initialize: ->
    _.bindAll(this, "performSearch", "render", "showControls", "colorize", "stripCSS", "formatDate", "remove")
    this.model.bind("change", this.colorize)
    this.model.bind("change:date", this.formatDate)
    this.model.bind("destroy", this.remove)
    this.bind('editing', this.editing)
    this.render()
    this.formatValues()

  render: ->
    html = _.template($('#entryTemplate').html(), this.model.toJSON())
    $(this.el).html(html)
    this.colorize()

  showControls: (e) ->
    this.controlsView = new EntryControlsView({model: this.model, entryView: this, event: e})
    this.trigger('editing')

  editing: ->
    $(this.el).effect('pulsate', {times: 2}, 150)

  colorize: ->
    status   = this.model.get('status')
    amount   = parseFloat(this.model.get('amount'))
    date     = Date.create(this.model.get('date'))
    today    = Date.create('today')
    total    = parseFloat(this.$('.total'))
    css      = []

    css.push('cleared') if status is 'Cleared'
    css.push('open') if status is 'Open'
    css.push('today') if date.daysSince(today) is 0
    css.push('posted') if date.isBefore(today)
    css.push('future') if date.isAfter(today)
    css.push('debit') if amount < 0.0
    css.push('credit') if amount > 0.0
    css.push('negative_balance') if total < 0.0

    this.stripCSS()
    $(this.el).addClass(css.join(' '))

  clearSearchResult: ->
    $(this.el).removeClass('fade')

  stripCSS: ->
    $(this.el).removeClass().addClass('entry')

  formatValues: ->
    this.formatDate()
    this.formatAmount()

  formatDate: ->
    shortDate = Date.create(this.model.get('date')).format('{MM}/{dd}/{yy}')
    this.$('.date').html(shortDate)

  formatAmount: ->
    cell = this.$('.amount')
    cell.html(parseFloat(cell.html()).toFixed(2))

  remove: ->
    location.reload()

  performSearch: (regex) ->
    status  = this.model.get('status')
    matches = this.model.get('payee').match(regex)

    unless status is 'Cleared' and matches
      $(this.el).addClass('fade')

  clearSearchResult: ->
    $(this.el).removeClass('fade')

  isSearchHit: ->
    return !$(this.el).hasClass('fade')

