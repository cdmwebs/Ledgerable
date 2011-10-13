require 'spec_helper'

describe "/recurring_entries/show.html.haml" do

  before do
    @ledger = Factory(:ledger)
    @category = Factory(:category)
    @entry = Factory(:entry)
    @recurring_entry = Factory(:recurring_entry, :ledger => @ledger, :category => @category)
    @recurring_entry.stub!(:entries => [@entry])

    assign(:ledger, @ledger)
    assign(:recurring_entry, @recurring_entry)
  end

  it "should have this title" do
    view.should_receive(:title).with(@recurring_entry)
    render
  end

  it "should have a delete button" do
    render
    rendered.should have_selector "a", :href => ledger_recurring_entry_path(@ledger, @recurring_entry), :class => "button", "data-method" => "delete"
  end

  it "should show these attributes" do
    render
    rendered.should have_selector "a", :href => ledger_path(@ledger)
    rendered.should contain "every month"
    rendered.should contain "2010-11-26"
    rendered.should contain "$1.00"
    rendered.should contain "10"
    rendered.should contain @category.name
    rendered.should contain "Memo"
  end

  it "should show the entry dates" do
    render
    rendered.should contain "Friday, November 19, 2010"
  end

end
