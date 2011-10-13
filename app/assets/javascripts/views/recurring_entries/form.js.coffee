class window.RecurringEntryFormView extends Backbone.View
  events:
    "click #save_button":           "trySave",
    "keyup #category":              "suggestCategories",
    "keyup #recurring_entry_payee": "suggestPayees",
    "blur #recurring_entry_payee" : "enterLastCategory",
    "click #recurrs_monthly":       "showMonthlyOptions",
    "click #recurrs_weekly":        "showWeeklyOptions"

  initialize: ->
    this.prefix         = "recurring_entry"
    this.recurrStyle    = false
    this.startDateInput = this.$("##{this.prefix}_start_date")
    this.payeeInput     = this.$("##{this.prefix}_payee")
    this.memoInput      = this.$("##{this.prefix}_memo")
    this.amountInput    = this.$("##{this.prefix}_amount")
    this.categoryInput  = this.$("#category")
    this.saveButton     = this.$("#save_button")
    this.dayofMonth     = this.$("##{this.prefix}_day_of_month")
    this.numberOfTimes  = this.$("##{this.prefix}_times")

  validate: ->
    this.errors = []
    this.validatePayee()
    this.validateCategory()
    this.validateStartDate()
    this.validateAmount()
    this.validateRecursion()

  validateRecursion: ->
    if this.recurrStyle is "monthly"
      this.validateMonthlyRecurrence()
      this.validateNumberOfTimes()

    else if this.recurrStyle is "weekly"
      this.validateNumberOfTimes()

    else
      this.errors.push('a recurrence type')

  validateNumberOfTimes: ->
    val = this.numberOfTimes.val()
    if val.length > 0
      this.errors.push('a valid number of times') unless val.match(/^\d+$/)
    else
      this.errors.push('a valid number of times')

  validateMonthlyRecurrence: ->
    val = this.dayofMonth.val()
    if val.length > 0
      this.errors.push('a valid recurrence day') unless val.match(/^\d{1,2}$/)
    else
      this.errors.push('a valid recurrence day')

  validatePayee: ->
    if this.payeeInput.val().length is 0
      this.errors.push("a payee")

  validateCategory: ->
    if this.categoryInput.val().length is 0
      this.errors.push("a category")

  validateStartDate: ->
    val = this.startDateInput.val()
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
      return formURL.replace(/\/recurring_entries$/, '')
    else
      return formURL.replace(/\/recurring_entries\/\d+/, '')

  payeePath: ->
    "#{this.ledgerPath()}/payees"

  lastCategoryPath: ->
    "#{this.ledgerPath()}/last_category"

  categoryListPath: ->
    "#{this.ledgerPath()}/category_list"

  suggestPayees: ->
    this.payeeInput.autocomplete({ source: this.payeePath(), minLength: 2 })

  enterLastCategory: ->
    _this = this
    $.get(this.lastCategoryPath(), {payee: this.payeeInput.val()}, (data) ->
      _this.categoryInput.val(data)
    )

  suggestCategories: ->
    this.categoryInput.autocomplete({ source: this.categoryListPath(), minLength: 2 })

  showMonthlyOptions: ->
    $("#choices").remove()
    $("#weekly").remove()
    $("#monthly").show()
    $("#times").show()
    this.recurrStyle = "monthly"

  showWeeklyOptions: ->
    $("#choices").remove()
    $("#monthly").remove()
    $("#weekly").show()
    $("#times").show()
    this.recurrStyle = "weekly"

