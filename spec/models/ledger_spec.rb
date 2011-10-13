require 'spec_helper'

describe Ledger do
  before do
    @ledger = Factory(:ledger)
  end

  it "should know how to find categories based on a term" do
    c1 = @ledger.categories.create(:name => "BAD")
    c2 = @ledger.categories.create(:name => "AAD")
    c3 = @ledger.categories.create(:name => "AND")
    @ledger.category_list("an").should == ["AND"]
  end

  it "should know how to find today's value" do
    @ledger.entries.create(:date => Date.yesterday, :amount => 50.0)
    @ledger.entries.create(:date => Date.yesterday, :amount => 50.0)
    @ledger.entries.create(:date => Date.tomorrow, :amount => 50.0)
    @ledger.todays_value.should == 100.00
  end

  it "should know how to find the value on a particular date" do
    @ledger.entries.create(:date => 2.months.ago, :amount => 50.0)
    @ledger.entries.create(:date => 1.month.ago, :amount => 50.0)
    @ledger.entries.create(:date => Date.yesterday, :amount => 50.0)
    @ledger.entries.create(:date => Date.today, :amount => 50.0)
    @ledger.entries.create(:date => 1.month.from_now, :amount => 50.0)
    @ledger.total_on_date(Date.yesterday).should == 150.00
  end

  it "should know how to find all entries in a two month window" do
    a = @ledger.entries.create(:date => 3.months.ago, :amount => 50.0)
    b = @ledger.entries.create(:date => 1.month.ago, :amount => 50.0)
    c = @ledger.entries.create(:date => 2.weeks.from_now, :amount => 50.0)
    d = @ledger.entries.create(:date => 5.weeks.from_now, :amount => 50.0)
    @ledger.two_month_window.should == [c,b]
  end

  it "should know how to find the start value for a two month window" do
    a = @ledger.entries.create(:date => 3.months.ago, :amount => 50.0)
    b = @ledger.entries.create(:date => 1.month.ago, :amount => 50.0)
    c = @ledger.entries.create(:date => 2.weeks.from_now, :amount => 50.0)
    d = @ledger.entries.create(:date => 5.weeks.from_now, :amount => 50.0)
    @ledger.two_month_window_start_value.should == 50.0
  end

  it "should know how to find all entries from the last thirty days" do
    a = @ledger.entries.create(:date => 3.months.ago, :amount => 50.0)
    b = @ledger.entries.create(:date => 3.weeks.ago, :amount => 50.0)
    c = @ledger.entries.create(:date => 2.weeks.ago, :amount => 50.0)
    d = @ledger.entries.create(:date => 5.weeks.from_now, :amount => 50.0)
    @ledger.past_thirty_days.should == [c,b]
  end

  it "should know how to find all entries from the last ninety days" do
    a = @ledger.entries.create(:date => 3.months.ago, :amount => 50.0)
    b = @ledger.entries.create(:date => 3.weeks.ago, :amount => 50.0)
    c = @ledger.entries.create(:date => 2.weeks.ago, :amount => 50.0)
    d = @ledger.entries.create(:date => 5.weeks.ago, :amount => 50.0)
    @ledger.past_ninety_days.should == [c,b,d]
  end

  it "should know how to find all entries from the last two weeks" do
    a = @ledger.entries.create(:date => 3.months.ago, :amount => 50.0)
    b = @ledger.entries.create(:date => 3.weeks.ago, :amount => 50.0)
    c = @ledger.entries.create(:date => 2.weeks.ago, :amount => 50.0)
    d = @ledger.entries.create(:date => 1.weeks.ago, :amount => 50.0)
    @ledger.last_two_weeks.should == [d,c]
  end

  it "should know how to calculate the value from the last thirty days" do
    a = @ledger.entries.create(:date => 3.months.ago, :amount => 50.0)
    b = @ledger.entries.create(:date => 3.weeks.ago, :amount => -50.0)
    c = @ledger.entries.create(:date => 2.weeks.ago, :amount => 100.0)
    d = @ledger.entries.create(:date => 5.weeks.from_now, :amount => 50.0)
    @ledger.past_thirty_days_amount(:credit).should == 100.0
    @ledger.past_thirty_days_amount(:debit).should == -50.0
  end

  it "should know how to print its self" do
    @ledger.to_s.should == "Ledger"
  end

  it "should know how to_param its self" do
    @ledger.to_param.should == "#{@ledger.id}-#{@ledger.name.parameterize}"
  end

  it "should know how to implement :to_json" do
    res = JSON.parse(@ledger.to_json)
    res["name"].should == @ledger.name
    res["id"].should == @ledger.id
    Date.parse(res["created_at"]).should == @ledger.created_at.to_date
    Date.parse(res["updated_at"]).should == @ledger.updated_at.to_date
  end

  it "should know about associated RecurringEntries" do
    @ledger.recurring_entries.should == []
  end

  it "should know how to search its self for Entries" do
    c1 = @ledger.categories.create(:name => "Misc1")
    c2 = @ledger.categories.create(:name => "Misc2")
    c3 = @ledger.categories.create(:name => "Misc3")
    c4 = @ledger.categories.create(:name => "Misc4")
    c5 = @ledger.categories.create(:name => "Misc5")

    e1 = @ledger.entries.create(:payee => "Payee1", :amount => -10.0, :date => Date.yesterday, :memo => "Test", :category_id => c1)
    e2 = @ledger.entries.create(:payee => "Payee2", :amount => 3.0, :date => 1.month.ago, :memo => "Test", :category_id => c2.id)
    e3 = @ledger.entries.create(:payee => "Payee3", :amount => -1.0, :date => 2.weeks.ago, :memo => "Test", :category_id => c3.id)
    e4 = @ledger.entries.create(:payee => "Payee4", :amount => 15.0, :date => 1.week.ago, :memo => "Test", :category_id => c4.id)
    e5 = @ledger.entries.create(:payee => "Payee5", :amount => 7.0, :date => 3.days.ago, :memo => "Test", :category_id => c5.id)

    @ledger.search({:payee => "Payee1"}).should == [e1]
    @ledger.search({:amount => 3.0}).should == [e2]
    @ledger.search({:category => "Misc4"}).should == [e4]
    @ledger.search({:start_date => 3.weeks.ago, :end_date => 1.week.ago}).should == [e4,e3]
    @ledger.search({:start_date => 3.weeks.ago, :end_date => 1.week.ago, :category => "Misc3"}).should == [e3]
  end

  describe "finding the last category for a payee" do
    context "when previous entries exist" do
      before do
        c1 = @ledger.categories.create(:name => "First")
        c2 = @ledger.categories.create(:name => "Second")
        @ledger.entries.create(:payee => "Test", :date => Date.today, :category => c2)
        @ledger.entries.create(:payee => "Test", :date => Date.yesterday, :category => c1)
      end

      it "should know how to find the last Category for a payee" do
        @ledger.last_category_for("Te").should == "Second"
      end
    end

    context "when previous entries dont' exist" do
      before do
        @ledger.stub!(:entries => [])
      end

      it "should know how to find the last Category for a payee" do
        @ledger.last_category_for("Test").should == ""
      end
    end
  end

  describe "finding a payee based on a term" do
    context "when previous payees exist" do
      before do
        @ledger.entries.create(:payee => "ABC")
        @ledger.entries.create(:payee => "ABC")
        @ledger.entries.create(:payee => "ABD")
        @ledger.entries.create(:payee => "DEF")
      end

      it "should know how to find payees based on a term" do
        @ledger.payees("AB").should == ["ABC", "ABD"]
      end
    end

    context "when previous payees don't exist" do
      it "should know how to find payees based on a term" do
        @ledger.payees("AB").should == []
      end
    end
  end

  describe "performing a backup" do
    before do
      Date.stub!(:today => Date.parse("2010-11-21"))
      c = @ledger.categories.create(:name => "Misc")
      e = @ledger.entries.create(:payee => "Test", :date => Date.today, :category => c)
    end

    it "should know how to perform a backup" do
      @ledger.to_qif.should == "^\nD11/21/2010\nPTest\nT\nM\nLMisc\nC"
    end

  end

end
