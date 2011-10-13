describe "RecurringEntryFormView", ->

  # Tell Backbone not to hit the DB
  Backbone.sync = (method, model, success, error) ->
    success()

  beforeEach ->
    loadFixtures('recurring_entry_form.html')
    initRecurringentryForm('new')
    @app      = window.app
    @date     = $('#recurring_entry_start_date')
    @payee    = $('#recurring_entry_payee')
    @memo     = $('#recurring_entry_memo')
    @amount   = $('#recurring_entry_amount')
    @category = $('#category')
    @submit   = $('#save_button')
    @errorDiv = $('#errors .list')

  describe "validation", ->
    beforeEach ->
      @date.val('2011-06-19')
      @payee.val('Matt Darby')
      @memo.val('Memo')
      @amount.val('100.00')
      @category.val('Misc')

    describe "when a date isn't set", ->
      it "has a validation error", ->
        @date.val('')
        @submit.click()
        expect(@errorDiv).toHaveText(/a valid date/)
        expect(@errorDiv).toBeVisible()

    describe "when a date isn't valid", ->
      it "has a validation error", ->
        @date.val('foo')
        @submit.click()
        expect(@errorDiv).toHaveText(/a valid date/)
        expect(@errorDiv).toBeVisible()

    describe "when a payee isn't set", ->
      it "has a validation error", ->
        @payee.val('')
        @submit.click()
        expect(@errorDiv).toHaveText(/a payee/)
        expect(@errorDiv).toBeVisible()

    describe "when a amount isn't set", ->
      it "has a validation error", ->
        @amount.val('')
        @submit.click()
        expect(@errorDiv).toHaveText(/a valid amount/)
        expect(@errorDiv).toBeVisible()

    describe "when a amount isn't valid", ->
      it "has a validation error", ->
        @amount.val('foo')
        @submit.click()
        expect(@errorDiv).toHaveText(/a valid amount/)
        expect(@errorDiv).toBeVisible()

    describe "when a category isn't set", ->
      it "has a validation error", ->
        @category.val('')
        @submit.click()
        expect(@errorDiv).toHaveText(/a category/)
        expect(@errorDiv).toBeVisible()


  describe "when used for a 'new' form", ->
    beforeEach ->
      @app.action = 'new'
      $('form').attr('action', '/ledgers/1/recurring_entries')

    it "knows the ledgerPath", ->
      expect(@app.ledgerPath()).toEqual('/ledgers/1')

    it "knows the how its element", ->
      expect(@app.el).toEqual('form.new_recurring_entry')


  describe "when used for a 'edit' form", ->
    beforeEach ->
      @editApp = initRecurringentryForm('edit')
      # Have to manually set these values as the fixture represents the 'new' form
      $('form').attr({class: 'edit_recurring_entry', action: '/ledgers/1/recurring_entries/2'})

    it "should know the ledgerPath", ->
      expect(@editApp.ledgerPath()).toEqual('/ledgers/1')

    it "knows the how its element", ->
      expect(@editApp.el).toEqual('form.edit_recurring_entry')


  it "enters the last used category based on a payee", ->
    _this = this
    $.get = jasmine.createSpy().andCallFake((path, data) ->
      expect(path).toEqual('/ledgers/1/last_category')
      expect(data).toEqual({payee: 'Mat'})
      _this.category.val('Category')
    )

    @payee.val('Mat').blur()
    expect(@category.val()).toEqual('Category')

  it "suggests payees based on entered text", ->
    _this = this
    $.fn.autocomplete = jasmine.createSpy().andCallFake((data) ->
      expect(data.source).toEqual('/ledgers/1/payees')
      expect(data.minLength).toEqual(2)
    )

    @payee.val('Mat').keyup()

  it "suggests categories based on entered text", ->
    _this = this
    $.fn.autocomplete = jasmine.createSpy().andCallFake((data) ->
      expect(data.source).toEqual('/ledgers/1/category_list')
      expect(data.minLength).toEqual(2)
    )

    @category.val('Cat').keyup()

  describe "selecting monthly recurrence", ->
    beforeEach ->
      $('#recurrs_monthly').click()

    it "should show monthly options", ->
      expect($('#monthly')).toBeVisible()
      expect($('#times')).toBeVisible()
      expect($('#weekly')).not.toExist()
      expect($('#choices')).not.toExist()

  describe "selecting weekly recurrence", ->
    beforeEach ->
      $('#recurrs_weekly').click()

    it "should show weekly options", ->
      expect($('#weekly')).toBeVisible()
      expect($('#times')).toBeVisible()
      expect($('#monthly')).not.toExist()
      expect($('#choices')).not.toExist()

