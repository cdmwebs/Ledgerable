require 'spec_helper'

describe EntryHelper do

  describe "status_css" do
    context "when the entry date is today" do
      it "should have the 'today' class" do
        t = Entry.create(:date => Date.today, :amount => 0.0)
        helper.status_css(t).should == "open posted today"
      end
    end

    context "when the entry date is cleared" do
      it "should have the 'cleared' class" do
        t = Entry.create(:date => Date.today, :amount => 0.0)
        t.cleared!
        helper.status_css(t).should == "cleared posted today"
      end
    end

    context "when the entry date is in the future" do
      it "should have the 'future' class" do
        t = Entry.create(:date => Date.tomorrow, :amount => 0.0)
        t.cleared!
        helper.status_css(t).should == "cleared future"
      end
    end

    context "when the entry is a debit" do
      it "should have the 'debit' class" do
        t = Entry.create(:date => 2.days.ago, :amount => -1.0)
        t.cleared!
        helper.status_css(t).should == "cleared posted debit"
      end
    end

    context "when the entry is a credit" do
      it "should have the 'credit' class" do
        t = Entry.create(:date => 2.days.ago, :amount => 1.0)
        t.cleared!
        helper.status_css(t).should == "cleared posted credit"
      end
    end

  end

end