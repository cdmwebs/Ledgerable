require 'spec_helper'

describe Entry do

  it "should know about its Category" do
    t = Entry.create(:date => 1.month.from_now, :amount => 50.0)
    t.respond_to?(:category).should be_true
  end

  it "should know how to order Entries" do
    a = Entry.create(:date => 2.weeks.from_now, :amount => 50.0)
    b = Entry.create(:date => 1.month.ago, :amount => 50.0)
    c = Entry.create(:date => 3.months.ago, :amount => 50.0)
    d = Entry.create(:date => 5.weeks.from_now, :amount => 50.0)
    Entry.all.should == [d,a,b,c]
  end

  it "should be 'Open' by default" do
    Entry.create(:date => Date.today).status.should == "Open"
  end

  it "should know how to confirm a Entry" do
    t = Entry.create(:date => Date.today)
    lambda{ t.cleared! }.should change(t, :status).to("Cleared")
  end

  it "should know how to unconfirm a Entry" do
    t = Entry.create(:date => Date.today)
    t.cleared!
    lambda{ t.uncleared! }.should change(t, :status).to("Open")
  end

  it "should know how to QIF its self" do
    c = Factory(:category)
    t = Entry.new(:payee => "A", :memo => "B", :date => Date.parse("2010-11-19"), :amount => -1.0, :status => "Cleared", :category => c)
    t.to_qif.should == "^\nD11/19/2010\nPA\nT-1.0\nMB\nLCategory\nCX"
  end

  it "should know if its cleared" do
    t = Entry.create(:payee => "Misc")
    t.cleared?.should be_false
    t.cleared!
    t.cleared?.should be_true
  end

  it "should know how to implement :to_json" do
    ledger = Factory(:ledger)
    category = Factory(:category)
    entry = Factory(:entry, :ledger => ledger, :category => category)

    res = JSON.parse(entry.to_json)
    res["date"].should == entry.date.to_s
    res["payee"].should == entry.payee
    res["memo"].should == entry.memo
    res["amount"].should == entry.amount
    res["status"].should == entry.status
    Date.parse(res["created_at"]).should == entry.created_at.to_date
    Date.parse(res["updated_at"]).should == entry.updated_at.to_date
    res["category"].should == entry.category.name
    res["id"].should == entry.id
    res["ledger_id"].should == entry.ledger.id
  end

  it "should sanitize the :amount attribute" do
    e = Entry.create(:payee => "Test", :amount => "$2,000.00")
    e.amount.should == 2000.0
  end

end
