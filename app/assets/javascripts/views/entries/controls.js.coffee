class window.EntryControlsView extends Backbone.View
  className: 'controls'

  events:
    "click .cleared": "cleared",
    "click .open": "open",
    "click .edit": "edit",
    "click .remove": "remove",
    "click .cancel": "unrender"

  initialize: ->
    _.bindAll(this, "render", "toggle", "cleared", "open", "edit", "unrender", "remove")
    this.model.bind("change:status", this.unrender)
    this.model.bind("remove", this.unrender)
    this.event = this.options.event
    this.render()

  render: ->
    html = _.template($('#controlsTemplate').html())
    $(this.el).html(html)
    $(this.el).append(this.nib())
    $('body').append(this.el)
    this.position()

  nib: ->
    return $('<div></div>').addClass('nib')

  position: ->
    $(this.el).css({
      position: 'absolute',
      top:      this.event.pageY - 10,
      left:     this.event.pageX + 10
    })

  toggle: ->
    $(this.el).toggle()

  cleared: ->
    this.model.cleared()

  open: ->
    this.model.open()

  unrender: ->
    $(this.el).effect('fade', 'fast')

  edit: ->
    $.colorbox({
      href:     this.model.editPath(),
      onClosed: -> location.reload(true)
    }).resize()

  remove: ->
    this.model.destroy() if confirm "Are you sure you want to remove this entry?"
