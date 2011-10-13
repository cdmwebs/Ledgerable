class window.LedgerFormView extends Backbone.View
  events:
    "click #save_button": "trySave",

  initialize: ->
    this.action    = this.options.action
    this.errorsDiv = $('#errors')
    this.nameInput = this.$('#ledger_name')

  validate: ->
    this.errors = []
    this.validateName()

  validateName: ->
    if this.nameInout.val().length is 0
      this.errors.push("a name")

  validated: ->
    this.validate()
    return this.errors.length is 0

  showErrors: ->
    str = "We still need #{this.errors.join(", ")}"
    this.errorsDiv.show().find('.list').html(str)

  hideErrors: ->
    this.errorsDiv.hide()

  trySave: (e) ->
    this.hideErrors()

    unless this.validated()
      e.preventDefault()
      this.showErrors()


window.initLedgerForm = (action) ->
  el = "form.#{action}_ledger"
  window.app = new LedgerFormView({el: el, action: action})
