class window.EntryFormView extends Backbone.View
  events:
    "click #save_button":    "trySave",
    "blur #entry_payee" :    "enterLastCategory"
    "keyup #entry_payee":    "suggestPayees"
    "keyup #entry_category": "suggestCategories"

  initialize: ->
    this.dateInput     = this.$('#entry_date')
    this.payeeInput    = this.$('#entry_payee')
    this.memoInput     = this.$('#entry_memo')
    this.amountInput   = this.$('#entry_amount')
    this.categoryInput = this.$('#entry_category')
    this.saveButton    = this.$('#save_button')

  validate: ->
    this.errors = []
    this.validatePayee()
    this.validateCategory()
    this.validateDate()
    this.validateAmount()

  validatePayee: ->
    if this.payeeInput.val().length is 0
      this.errors.push("a payee")

  validateCategory: ->
    if this.categoryInput.val().length is 0
      this.errors.push("a category")

  validateDate: ->
    val = this.dateInput.val()
    if val.length is 0
      this.errors.push("a valid date")
    else
      unless val.match(/^\d{4}-\d{2}-\d{2}$/)
        this.errors.push("a valid date")

  validateAmount: ->
    val = this.amountInput.val()
    if val.length is 0
      this.errors.push("a valid amount")
    else
      unless val.match(/^-?\d+\.?\d{0,2}$/)
        this.errors.push("a valid amount")

  validated: ->
    this.validate()
    return this.errors.length is 0

  showErrors: ->
    alert "We still need #{this.errors.join(", ")}"

  trySave: (e) ->
    unless this.validated()
      e.preventDefault()
      this.showErrors()

  ledgerPath: ->
    action  = $(this.el).attr('id')
    formURL = $(this.el).attr('action')

    if action.match(/new/)
      return formURL.replace(/\/entries$/, '')
    else
      return formURL.replace(/\/entries\/\d+/, '')

  payeePath: ->
    "#{this.ledgerPath()}/payees"

  lastCategoryPath: ->
    "#{this.ledgerPath()}/last_category"

  categoryListPath: ->
    "#{this.ledgerPath()}/category_list"

  suggestPayees: ->
    this.payeeInput.autocomplete({ source: this.payeePath(), minLength: 2 });

  enterLastCategory: ->
    _this = this
    $.get this.lastCategoryPath(), {payee: this.payeeInput.val()}, (data) ->
      _this.categoryInput.val(data)

  suggestCategories: ->
    this.categoryInput.autocomplete({ source: this.categoryListPath(), minLength: 2 });

