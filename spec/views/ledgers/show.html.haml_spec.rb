require 'spec_helper'

describe "/ledgers/show.html.haml" do

  before do
    @ledger    = Factory(:ledger)
    @category  = Factory(:category, :ledger => @ledger)
    @sparkline = mock('sparkline', :img_src => "sparkline", :tip => "tip")

    @entry = @ledger.entries.create({
      :date     => Date.today,
      :payee    => "Testing",
      :memo     => "Memo",
      :amount   => 1.0,
      :category => @category
    })

    assign(:starting_value, 3.0)
    assign(:ledger, @ledger)

    @chart = mock("chart", :img_src => "src", :tip => "tip")
    @ledger.stub!(:overview_chart).and_return(@chart)

    @user = Factory(:user)
    view.stub!(:current_user => @user)
  end

  it "should have this table header" do
    render
    rendered.should have_selector "th", :content => "Date", :class => "date"
    rendered.should have_selector "th", :content => "Category", :class => "category"
    rendered.should have_selector "th", :content => "Payee", :class => "payee"
    rendered.should have_selector "th", :content => "Memo", :class => "memo"
    rendered.should have_selector "th", :content => "Amount", :class => "amount"
    rendered.should have_selector "th", :content => "Total", :class => "total"
  end

  it "should today's value" do
    render
    rendered.should have_selector "div", :id => "todays_value" do |s|
      s.should have_selector "div", :class => "value"
    end
  end

  it "should have a new entry link" do
    render
    rendered.should have_selector "li", :class => "add_entry" do |c|
      c.should have_selector "a", :content => "Add Entry"
    end
  end

  it "should have a graphs link" do
    render
    rendered.should have_selector "li", :class => "graphs" do |c|
      c.should have_selector "a", :content => "Graphs"
    end
  end

  it "should have a backup link" do
    render
    rendered.should have_selector "a", :href => backup_ledger_path(@ledger)
  end

  it "should have a link to recurring_entries" do
    render
    rendered.should have_selector "a", :href => ledger_recurring_entries_path(@ledger)
  end

  it "should have a link to search" do
    render
    rendered.should have_selector "a", :href => ledger_search_path(@ledger)
  end

  it "should show a delete link" do
    render
    rendered.should have_selector "a", :href => ledger_path(@ledger), "data-method" => "delete"
  end

  it "should have a edit link" do
    render
    rendered.should have_selector "li", :class => "edit" do |c|
      c.should have_selector "a", :content => "Edit"
    end
  end
end
