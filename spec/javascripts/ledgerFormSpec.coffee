describe "LedgerFormView", ->

  # Tell Backbone not to hit the DB
  Backbone.sync = (method, model, success, error) ->
    success()

  beforeEach ->
    loadFixtures('ledger_form.html')
    initLedgerForm('new')
    @app      = window.app
    @name     = $('#ledger_name')
    @submit   = $('#save_button')
    @errorDiv = $('#errors .list')

  describe "validation", ->
    describe "when a name isn't set", ->
      it "has a validation error", ->
        @name.val('')
        @submit.click()
        expect(@errorDiv).toHaveText(/a name/)
        expect(@errorDiv).toBeVisible()
