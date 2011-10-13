require 'spec_helper'

describe RecurringEntry do

  before do
    @ledger = Factory(:ledger)
    @category = Factory(:category)
    @recurring_entry = Factory(:recurring_entry, :ledger => @ledger, :category => @category)
  end

  after do
    @ledger.entries.destroy_all
  end

  it "should know about an associated Ledger" do
    @recurring_entry.ledger.should == @ledger
  end

  it "should know about an associated Category" do
    @recurring_entry.category.should == @category
  end

  it "should know about associated Entries" do
    @recurring_entry.respond_to?(:entries).should be_true
  end

  it "should know how to print its self" do
    @recurring_entry.to_s.should == "$1.00 payment to Payee every month on the 26th"
  end

  describe "handling insertion of recurring Entries" do
    before do
      @ledger.entries.destroy_all
      @opts = Factory.attributes_for(:recurring_entry)
      @opts[:ledger_id] = @ledger.id
      @opts[:category_id] = @category.id
    end

    context "when specifying a Monthly period" do
      before do
        @opts[:period] = "Monthly"
        @opts[:times] = 5
        @opts[:day_of_month] = 26
      end

      it "should setup these Entries" do
        @ledger.recurring_entries.create(@opts)
        @ledger.reload
        @ledger.entries.size.should == 5
        @ledger.entries.first.date.should == Date.parse("2011-03-26")
      end
    end

    context "when specifying a Weekly period" do
      before do
        @opts[:period] = "Weekly"
        @opts[:times] = 5
      end

      it "should setup these Entries" do
        @ledger.recurring_entries.create(@opts)
        @ledger.reload
        @ledger.entries.size.should == 5
        @ledger.entries.first.date.should == Date.parse("2010-12-24")
      end
    end

    context "when specifying a Bi-weekly period" do
      before do
        @opts[:period] = "Bi-Weekly"
        @opts[:times] = 5
      end

      it "should setup these Entries" do
        @ledger.recurring_entries.create(@opts)
        @ledger.reload
        @ledger.entries.size.should == 5
        @ledger.entries.first.date.should == Date.parse("2011-01-21")
      end
    end

  end

  describe "handling :destroy" do
    before do
      @opts = Factory.attributes_for(:recurring_entry)
      @opts[:start_date] = Date.today
      @opts[:times] = 5
      @rt = @ledger.recurring_entries.create(@opts)
      @ledger.reload
    end

    it "should only destroy future entries" do
      lambda do
        @rt.destroy
      end.should change(@ledger.entries, :size).by(-4)
    end
  end

end
