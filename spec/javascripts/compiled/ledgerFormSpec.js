(function() {
  describe("LedgerFormView", function() {
    Backbone.sync = function(method, model, success, error) {
      return success();
    };
    beforeEach(function() {
      loadFixtures('ledger_form.html');
      initLedgerForm('new');
      this.app = window.app;
      this.name = $('#ledger_name');
      this.submit = $('#save_button');
      return this.errorDiv = $('#errors .list');
    });
    return describe("validation", function() {
      return describe("when a name isn't set", function() {
        return it("has a validation error", function() {
          this.name.val('');
          this.submit.click();
          expect(this.errorDiv).toHaveText(/a name/);
          return expect(this.errorDiv).toBeVisible();
        });
      });
    });
  });
}).call(this);
