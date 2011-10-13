require 'spec_helper'

describe "/recurring_entries/new.html.haml" do

  before do
    @ledger = Factory(:ledger)
    @category = Factory(:category)
    @recurring_entry = Factory(:recurring_entry, :ledger => @ledger, :category => @category)
  end

  it "should have this title" do
    view.should_receive(:title).with("#{@ledger.name} &rarr; New Recurring Entry")
    render
  end

  it "should show any errors" do
    view.should_receive(:errors)
    render
  end

  it "should have this form" do
    render
    rendered.should have_selector "form", :action => ledger_recurring_entries_path(@ledger) do |s|
      s.should have_selector "input", :name => "recurring_entry[payee]"
      s.should have_selector "input", :name => "recurring_entry[memo]"
      s.should have_selector "input", :name => "recurring_entry[amount]"

      # One of these :period controls will be removed in the process, but need both at first
      s.should have_selector "select", :name => "recurring_entry[period]"
      s.should have_selector "input", :name => "recurring_entry[period]", :type => "hidden", :value => "Monthly"

      s.should have_selector "input", :name => "recurring_entry[day_of_month]"
      s.should have_selector "input", :name => "recurring_entry[times]"
      s.should have_selector "input", :name => "category"
      s.should have_selector "input", :type => "submit"
    end
  end

end
