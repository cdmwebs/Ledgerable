class window.LoadingView extends Backbone.View
  el: '#loading'

  initialize: ->
    this.render()

  render: ->
    $(this.el).html('Loading...').hide()

  toggle: ->
    $(this.el).fadeToggle('fast')

