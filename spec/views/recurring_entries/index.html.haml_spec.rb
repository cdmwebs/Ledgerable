require 'spec_helper'

describe "/recurring_entries/index.html.haml" do

  before do
    @ledger = Factory(:ledger)
    @category = Factory(:category)
    @recurring_entry = Factory(:recurring_entry, :ledger => @ledger, :category => @category)

    assign(:recurring_entries, [@recurring_entry])
  end

  it "should have this title" do
    view.should_receive(:title).with("#{@ledger.name} &rarr; Recurring Entries")
    render
  end

  it "should show a link to the create a new recurring_entry" do
    render
    rendered.should have_selector "a", :href => new_ledger_recurring_entry_path(@ledger), :class => "button"
  end

  it "should show a link to the recurring_entry" do
    render
    rendered.should have_selector "a", :href => ledger_recurring_entry_path(@ledger, @recurring_entry)
  end

end
