(function() {
  describe("RecurringTransactionFormView", function() {
    Backbone.sync = function(method, model, success, error) {
      return success();
    };
    beforeEach(function() {
      loadFixtures('recurring_transaction_form.html');
      initRecurringTransactionForm('new');
      this.app = window.app;
      this.date = $('#recurring_transaction_start_date');
      this.payee = $('#recurring_transaction_payee');
      this.memo = $('#recurring_transaction_memo');
      this.amount = $('#recurring_transaction_amount');
      this.category = $('#category');
      this.submit = $('#save_button');
      return this.errorDiv = $('#errors .list');
    });
    describe("validation", function() {
      beforeEach(function() {
        this.date.val('2011-06-19');
        this.payee.val('Matt Darby');
        this.memo.val('Memo');
        this.amount.val('100.00');
        return this.category.val('Misc');
      });
      describe("when a date isn't set", function() {
        return it("has a validation error", function() {
          this.date.val('');
          this.submit.click();
          expect(this.errorDiv).toHaveText(/a valid date/);
          return expect(this.errorDiv).toBeVisible();
        });
      });
      describe("when a date isn't valid", function() {
        return it("has a validation error", function() {
          this.date.val('foo');
          this.submit.click();
          expect(this.errorDiv).toHaveText(/a valid date/);
          return expect(this.errorDiv).toBeVisible();
        });
      });
      describe("when a payee isn't set", function() {
        return it("has a validation error", function() {
          this.payee.val('');
          this.submit.click();
          expect(this.errorDiv).toHaveText(/a payee/);
          return expect(this.errorDiv).toBeVisible();
        });
      });
      describe("when a amount isn't set", function() {
        return it("has a validation error", function() {
          this.amount.val('');
          this.submit.click();
          expect(this.errorDiv).toHaveText(/a valid amount/);
          return expect(this.errorDiv).toBeVisible();
        });
      });
      describe("when a amount isn't valid", function() {
        return it("has a validation error", function() {
          this.amount.val('foo');
          this.submit.click();
          expect(this.errorDiv).toHaveText(/a valid amount/);
          return expect(this.errorDiv).toBeVisible();
        });
      });
      return describe("when a category isn't set", function() {
        return it("has a validation error", function() {
          this.category.val('');
          this.submit.click();
          expect(this.errorDiv).toHaveText(/a category/);
          return expect(this.errorDiv).toBeVisible();
        });
      });
    });
    describe("when used for a 'new' form", function() {
      beforeEach(function() {
        this.app.action = 'new';
        return $('form').attr('action', '/ledgers/1/recurring_transactions');
      });
      it("knows the ledgerPath", function() {
        return expect(this.app.ledgerPath()).toEqual('/ledgers/1');
      });
      return it("knows the how its element", function() {
        return expect(this.app.el).toEqual('form.new_recurring_transaction');
      });
    });
    describe("when used for a 'edit' form", function() {
      beforeEach(function() {
        this.editApp = initRecurringTransactionForm('edit');
        return $('form').attr({
          "class": 'edit_recurring_transaction',
          action: '/ledgers/1/recurring_transactions/2'
        });
      });
      it("should know the ledgerPath", function() {
        return expect(this.editApp.ledgerPath()).toEqual('/ledgers/1');
      });
      return it("knows the how its element", function() {
        return expect(this.editApp.el).toEqual('form.edit_recurring_transaction');
      });
    });
    it("enters the last used category based on a payee", function() {
      var _this;
      _this = this;
      $.get = jasmine.createSpy().andCallFake(function(path, data) {
        expect(path).toEqual('/ledgers/1/last_category');
        expect(data).toEqual({
          payee: 'Mat'
        });
        return _this.category.val('Category');
      });
      this.payee.val('Mat').blur();
      return expect(this.category.val()).toEqual('Category');
    });
    it("suggests payees based on entered text", function() {
      var _this;
      _this = this;
      $.fn.autocomplete = jasmine.createSpy().andCallFake(function(data) {
        expect(data.source).toEqual('/ledgers/1/payees');
        return expect(data.minLength).toEqual(2);
      });
      return this.payee.val('Mat').keyup();
    });
    it("suggests categories based on entered text", function() {
      var _this;
      _this = this;
      $.fn.autocomplete = jasmine.createSpy().andCallFake(function(data) {
        expect(data.source).toEqual('/ledgers/1/category_list');
        return expect(data.minLength).toEqual(2);
      });
      return this.category.val('Cat').keyup();
    });
    describe("selecting monthly recurrence", function() {
      beforeEach(function() {
        return $('#recurrs_monthly').click();
      });
      return it("should show monthly options", function() {
        expect($('#monthly')).toBeVisible();
        expect($('#times')).toBeVisible();
        expect($('#weekly')).not.toExist();
        return expect($('#choices')).not.toExist();
      });
    });
    return describe("selecting weekly recurrence", function() {
      beforeEach(function() {
        return $('#recurrs_weekly').click();
      });
      return it("should show weekly options", function() {
        expect($('#weekly')).toBeVisible();
        expect($('#times')).toBeVisible();
        expect($('#monthly')).not.toExist();
        return expect($('#choices')).not.toExist();
      });
    });
  });
}).call(this);
