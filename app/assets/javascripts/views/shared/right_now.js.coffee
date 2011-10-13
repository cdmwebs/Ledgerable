class window.RightNowView extends Backbone.View
  el: '#todays_value .value'

  initialize: ->
    this.render()

  render: ->
    $(this.el).html("$#{(window.ledger.get('todays_value')).toFixed(2)}")

