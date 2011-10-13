describe "Ledgerable", ->

  # Tell Backbone not to hit the DB
  Backbone.sync = (method, model, success, error) ->
    success()

  beforeEach ->
    loadFixtures('fixture.html')

    @entries = [
      {"date":"2011-06-14","payee":"First Payee","memo":"First Memo","amount":-221.55,"status":"Cleared","created_at":"2011-02-26T16:55:46-05:00","updated_at":"2011-02-26T16:55:46-05:00","category":"Insurance","id":"1","ledger_id":"1"},
      {"date":"2011-06-13","payee":"Second Payee","memo":"Second Memo","amount":-89.48,"status":"Open","created_at":"2011-02-26T16:56:28-05:00","updated_at":"2011-02-26T16:56:28-05:00","category":"Insurance","id":"2","ledger_id":"1"},
      {"date":"2011-06-10","payee":"Third Payee","memo":" (4/60)","amount":2902.21,"status":"Cleared","created_at":"2011-04-29T07:38:07-04:00","updated_at":"2011-04-29T07:38:07-04:00","category":"Salary","id":"3","ledger_id":"1"}
    ]

    initLedgerable(1, 1000.0, 5000.0, @entries)

    @app    = window.app
    @ledger = @app.ledger


  describe "App", ->
    it "should have three entries", ->
      expect(@app.collection.length).toEqual(3)

    it "should have a ledger", ->
      expect(@app.ledger).toBeDefined()

    it "should resize the ledger on window resize", ->
      spyOn(@app, "resize")
      $(window).trigger('resize')
      expect(@app.resize).toHaveBeenCalled()


  describe "Ledger", ->
    beforeEach ->
      @ledger = @app.ledger

    it "should render all entries", ->
      expect($(@ledger.el).find('.entry').size()).toEqual(3)


  describe "Entry", ->
    beforeEach ->
      @entry = @ledger.collection.at(0)

    it "knows how to JSONify itself", ->
      expected = {entry: {date: '2011-06-14', payee: 'First Payee', memo: 'First Memo', amount: -221.55, status: 'Cleared', created_at: '2011-02-26T16:55:46-05:00', updated_at: '2011-02-26T16:55:46-05:00', category: 'Insurance', id: '1', ledger_id: '1'}}
      expect(@entry.toJSON()).toEqual(expected)

    it "knows its editPath", ->
      expect(@entry.editPath()).toEqual("/ledgers/1/entries/1/edit")

    describe "when new", ->
      beforeEach ->
        @entry = @ledger.collection.at(1)
        @entry.set({id: undefined})
        expect(@entry.isNew()).toBeTruthy()

      it "knows its URL", ->
        expect(@entry.url()).toEqual("/ledgers/1/entries")


    describe "when not new", ->
      beforeEach ->
        @entry = @ledger.collection.at(1)

      it "knows its URL", ->
        expect(@entry.url()).toEqual("/ledgers/1/entries/2")


    describe "when open", ->
      beforeEach ->
        @entry = @ledger.collection.at(1)
        expect(@entry.get('status')).toEqual('Open')

      it "knows how to close its self", ->
        @entry.cleared()
        expect(@entry.get('status')).toEqual('Cleared')


    describe "when closed", ->
      beforeEach ->
        @entry = @ledger.collection.at(0)
        expect(@entry.get('status')).toEqual('Cleared')

      it "knows how to open its self", ->
        @entry.open()
        expect(@entry.get('status')).toEqual('Open')


  describe "EntryView", ->
    beforeEach ->
      @lineItem  = @ledger.lineItems[0]
      @entry     = @lineItem.model
      @entryView = @lineItem.entryView
      @controls  = @lineItem.controlsView

    it "should have a Controls view", ->
      expect(@entryView.controlsView).toBeDefined()

    it "should toggle the Controls on click", ->
      expect($(@controls.el)).toBeHidden()
      $(@entryView.el).click()
      expect($(@controls.el)).toBeVisible()

    it "should know how to strip css classes", ->
      @entryView.stripCSS()
      classes = $(@entryView.el).attr('class').split(/\s+/)
      expect(classes.length).toEqual(1)
      expect($(@entryView.el)).toHaveClass('entry')

    describe "when it has been cleared", ->
      it "should have the 'cleared' class", ->
        console.log $(@entryView.el)
        expect($(@entryView.el)).toHaveClass('cleared')

    describe "when it is open", ->
      it "should have the 'open' class", ->
        @entry.open()
        expect($(@entryView.el)).toHaveClass('open')

    describe "when its date is today", ->
      beforeEach ->
        date = new Date()
        now = date.format('yyyy-mm-d')
        @entry.set({date: now})

      it "should have the 'today' class", ->
        expect($(@entryView.el)).toHaveClass('today')

    describe "representing its self as HTML", ->
      beforeEach ->
        @el = $(@entryView.el)

      it "should be wrapped in this element", ->
        expect(@el).toBe("tr.entry")

      it "should show the date", ->
        expect(@el.find("td.date").html()).toEqual("6/14")

      it "should show the category", ->
        expect(@el.find("td.category").html()).toEqual("Insurance")

      it "should show the payee", ->
        expect(@el.find("td.payee").html()).toEqual("First Payee")

      it "should show the memo", ->
        expect(@el.find("td.memo").html()).toEqual("First Memo")

      it "should show the amount", ->
        expect(@el.find("td.amount").html()).toEqual("-221.55")


  describe "Controls", ->
    beforeEach ->
      @entrView  = @ledger.entryViews[0]
      @entry     = @entryView.model
      @controls  = @entryView.controlsView

    describe "representing its self as HTML", ->
      beforeEach ->
        @el = $(@controls.el)

      it "should be wrapped in this element", ->
        expect(@el).toBe("tr.controls")

      it "should show a cleared li", ->
        expect(@el.find("li.cleared").html()).toEqual("Cleared")

      it "should show a open li", ->
        expect(@el.find("li.open").html()).toEqual("Open")

      it "should show an edit li", ->
        expect(@el.find("li.edit").html()).toEqual("Edit")

      it "should show a remove li", ->
        expect(@el.find("li.remove").html()).toEqual("Remove")

      it "should show a cancel li", ->
        expect(@el.find("li.cancel").html()).toEqual("cancel")


    describe "interacting with the controls", ->
      describe "clearing the entry", ->
        beforeEach ->
          $(@controls.el).find('.cleared').trigger('click')

        it "should hide the controls", ->
          expect($(@controls.el)).toBeHidden()

        it "should update the Entry as cleared", ->
          expect(@controls.model.get('status')).toEqual('Cleared')

        it "should show the Entry as cleared", ->
          expect($(@entryView.el)).toHaveClass('cleared')


    describe "opening the entry", ->
      beforeEach ->
        $(@controls.el).find('.open').trigger('click')

      it "should hide the controls", ->
        expect($(@controls.el)).toBeHidden()

      it "should update the Entry as open", ->
        expect(@controls.model.get('status')).toEqual('Open')

      it "should show the Entry as open", ->
        expect($(@entryView.el)).toHaveClass('open')


  describe "RightNowView", ->
    beforeEach ->
      @rnv = @app.rightNowView

    it "knows its element", ->
      expect(@rnv.el).toEqual('#todays_value .value')

    it "shows the current value of the Ledger", ->
      expect($(@rnv.el).html()).toEqual("$1,000.00")

    describe "after removing an entry", ->
      beforeEach ->
        @app.collection.at(0).destroy()

      it "shows the current value of the Ledger", ->
        expect($(@rnv.el).html()).toEqual("$1,221.55")

