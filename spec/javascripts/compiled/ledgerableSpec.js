(function() {
  describe("Ledgerable", function() {
    Backbone.sync = function(method, model, success, error) {
      return success();
    };
    beforeEach(function() {
      loadFixtures('fixture.html');
      this.entries = [
        {
          "date": "2011-06-14",
          "payee": "First Payee",
          "memo": "First Memo",
          "amount": -221.55,
          "status": "Cleared",
          "created_at": "2011-02-26T16:55:46-05:00",
          "updated_at": "2011-02-26T16:55:46-05:00",
          "category": "Insurance",
          "id": "1",
          "ledger_id": "1"
        }, {
          "date": "2011-06-13",
          "payee": "Second Payee",
          "memo": "Second Memo",
          "amount": -89.48,
          "status": "Open",
          "created_at": "2011-02-26T16:56:28-05:00",
          "updated_at": "2011-02-26T16:56:28-05:00",
          "category": "Insurance",
          "id": "2",
          "ledger_id": "1"
        }, {
          "date": "2011-06-10",
          "payee": "Third Payee",
          "memo": " (4/60)",
          "amount": 2902.21,
          "status": "Cleared",
          "created_at": "2011-04-29T07:38:07-04:00",
          "updated_at": "2011-04-29T07:38:07-04:00",
          "category": "Salary",
          "id": "3",
          "ledger_id": "1"
        }
      ];
      initLedgerable(1, 1000.0, 5000.0, this.entries);
      this.app = window.app;
      return this.ledger = this.app.ledger;
    });
    describe("App", function() {
      it("should have three entries", function() {
        return expect(this.app.collection.length).toEqual(3);
      });
      it("should have a ledger", function() {
        return expect(this.app.ledger).toBeDefined();
      });
      return it("should resize the ledger on window resize", function() {
        spyOn(this.app, "resize");
        $(window).trigger('resize');
        return expect(this.app.resize).toHaveBeenCalled();
      });
    });
    describe("Ledger", function() {
      beforeEach(function() {
        return this.ledger = this.app.ledger;
      });
      return it("should render all entries", function() {
        return expect($(this.ledger.el).find('.entry').size()).toEqual(3);
      });
    });
    describe("Entry", function() {
      beforeEach(function() {
        return this.entry = this.ledger.collection.at(0);
      });
      it("knows how to JSONify itself", function() {
        var expected;
        expected = {
          entry: {
            date: '2011-06-14',
            payee: 'First Payee',
            memo: 'First Memo',
            amount: -221.55,
            status: 'Cleared',
            created_at: '2011-02-26T16:55:46-05:00',
            updated_at: '2011-02-26T16:55:46-05:00',
            category: 'Insurance',
            id: '1',
            ledger_id: '1'
          }
        };
        return expect(this.entry.toJSON()).toEqual(expected);
      });
      it("knows its editPath", function() {
        return expect(this.entry.editPath()).toEqual("/ledgers/1/entries/1/edit");
      });
      describe("when new", function() {
        beforeEach(function() {
          this.entry = this.ledger.collection.at(1);
          this.entry.set({
            id: void 0
          });
          return expect(this.entry.isNew()).toBeTruthy();
        });
        return it("knows its URL", function() {
          return expect(this.entry.url()).toEqual("/ledgers/1/entries");
        });
      });
      describe("when not new", function() {
        beforeEach(function() {
          return this.entry = this.ledger.collection.at(1);
        });
        return it("knows its URL", function() {
          return expect(this.entry.url()).toEqual("/ledgers/1/entries/2");
        });
      });
      describe("when open", function() {
        beforeEach(function() {
          this.entry = this.ledger.collection.at(1);
          return expect(this.entry.get('status')).toEqual('Open');
        });
        return it("knows how to close its self", function() {
          this.entry.cleared();
          return expect(this.entry.get('status')).toEqual('Cleared');
        });
      });
      return describe("when closed", function() {
        beforeEach(function() {
          this.entry = this.ledger.collection.at(0);
          return expect(this.entry.get('status')).toEqual('Cleared');
        });
        return it("knows how to open its self", function() {
          this.entry.open();
          return expect(this.entry.get('status')).toEqual('Open');
        });
      });
    });
    describe("EntryView", function() {
      beforeEach(function() {
        this.lineItem = this.ledger.lineItems[0];
        this.entry = this.lineItem.model;
        this.entryView = this.lineItem.entryView;
        return this.controls = this.lineItem.controlsView;
      });
      it("should have a Controls view", function() {
        return expect(this.entryView.controlsView).toBeDefined();
      });
      it("should toggle the Controls on click", function() {
        expect($(this.controls.el)).toBeHidden();
        $(this.entryView.el).click();
        return expect($(this.controls.el)).toBeVisible();
      });
      it("should know how to strip css classes", function() {
        var classes;
        this.entryView.stripCSS();
        classes = $(this.entryView.el).attr('class').split(/\s+/);
        expect(classes.length).toEqual(1);
        return expect($(this.entryView.el)).toHaveClass('entry');
      });
      describe("when it has been cleared", function() {
        return it("should have the 'cleared' class", function() {
          console.log($(this.entryView.el));
          return expect($(this.entryView.el)).toHaveClass('cleared');
        });
      });
      describe("when it is open", function() {
        return it("should have the 'open' class", function() {
          this.entry.open();
          return expect($(this.entryView.el)).toHaveClass('open');
        });
      });
      describe("when its date is today", function() {
        beforeEach(function() {
          var date, now;
          date = new Date();
          now = date.format('yyyy-mm-d');
          return this.entry.set({
            date: now
          });
        });
        return it("should have the 'today' class", function() {
          return expect($(this.entryView.el)).toHaveClass('today');
        });
      });
      return describe("representing its self as HTML", function() {
        beforeEach(function() {
          return this.el = $(this.entryView.el);
        });
        it("should be wrapped in this element", function() {
          return expect(this.el).toBe("tr.entry");
        });
        it("should show the date", function() {
          return expect(this.el.find("td.date").html()).toEqual("6/14");
        });
        it("should show the category", function() {
          return expect(this.el.find("td.category").html()).toEqual("Insurance");
        });
        it("should show the payee", function() {
          return expect(this.el.find("td.payee").html()).toEqual("First Payee");
        });
        it("should show the memo", function() {
          return expect(this.el.find("td.memo").html()).toEqual("First Memo");
        });
        return it("should show the amount", function() {
          return expect(this.el.find("td.amount").html()).toEqual("-221.55");
        });
      });
    });
    describe("Controls", function() {
      beforeEach(function() {
        this.entrView = this.ledger.entryViews[0];
        this.entry = this.entryView.model;
        return this.controls = this.entryView.controlsView;
      });
      describe("representing its self as HTML", function() {
        beforeEach(function() {
          return this.el = $(this.controls.el);
        });
        it("should be wrapped in this element", function() {
          return expect(this.el).toBe("tr.controls");
        });
        it("should show a cleared li", function() {
          return expect(this.el.find("li.cleared").html()).toEqual("Cleared");
        });
        it("should show a open li", function() {
          return expect(this.el.find("li.open").html()).toEqual("Open");
        });
        it("should show an edit li", function() {
          return expect(this.el.find("li.edit").html()).toEqual("Edit");
        });
        it("should show a remove li", function() {
          return expect(this.el.find("li.remove").html()).toEqual("Remove");
        });
        return it("should show a cancel li", function() {
          return expect(this.el.find("li.cancel").html()).toEqual("cancel");
        });
      });
      describe("interacting with the controls", function() {
        return describe("clearing the entry", function() {
          beforeEach(function() {
            return $(this.controls.el).find('.cleared').trigger('click');
          });
          it("should hide the controls", function() {
            return expect($(this.controls.el)).toBeHidden();
          });
          it("should update the Entry as cleared", function() {
            return expect(this.controls.model.get('status')).toEqual('Cleared');
          });
          return it("should show the Entry as cleared", function() {
            return expect($(this.entryView.el)).toHaveClass('cleared');
          });
        });
      });
      return describe("opening the entry", function() {
        beforeEach(function() {
          return $(this.controls.el).find('.open').trigger('click');
        });
        it("should hide the controls", function() {
          return expect($(this.controls.el)).toBeHidden();
        });
        it("should update the Entry as open", function() {
          return expect(this.controls.model.get('status')).toEqual('Open');
        });
        return it("should show the Entry as open", function() {
          return expect($(this.entryView.el)).toHaveClass('open');
        });
      });
    });
    return describe("RightNowView", function() {
      beforeEach(function() {
        return this.rnv = this.app.rightNowView;
      });
      it("knows its element", function() {
        return expect(this.rnv.el).toEqual('#todays_value .value');
      });
      it("shows the current value of the Ledger", function() {
        return expect($(this.rnv.el).html()).toEqual("$1,000.00");
      });
      return describe("after removing an entry", function() {
        beforeEach(function() {
          return this.app.collection.at(0).destroy();
        });
        return it("shows the current value of the Ledger", function() {
          return expect($(this.rnv.el).html()).toEqual("$1,221.55");
        });
      });
    });
  });
}).call(this);
