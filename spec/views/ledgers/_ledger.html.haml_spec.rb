require 'spec_helper'

describe "/ledgers/_ledger.html.haml" do
  before do
    @ledger = Factory(:ledger)
    @category = Factory(:category)
    @entry = Factory(:entry, :category => @category)

    assign(:ledger, @ledger)
    assign(:entries, [@entry])
  end

  it "should show the entry" do
    render
    rendered.should have_selector "tr", :id => @entry.id.to_s, :class => "credit entry open posted" do |s|
      s.should have_selector "td", :content => @entry.date.strftime("%m/%d"), :class => "date"
      s.should have_selector "td", :content => "Category", :class => "category"
      s.should have_selector "td", :content => "Payee", :class => "payee"
      s.should have_selector "td", :content => "Memo", :class => "memo"
      s.should have_selector "td", :content => "1.0", :class => "amount"
      s.should have_selector "td", :content => "", :class => "total"
    end
  end

  it "should have a hidden actions area" do
    render
    rendered.should have_selector "tr", :class => "actions", :style => "display:none;" do |s|
      s.should have_selector "a", :onclick => "confirmEntry('#{@entry.id}'); return false;", :content => "Cleared"
      s.should have_selector "a", :onclick => "unconfirmEntry('#{@entry.id}'); return false;", :content => "Uncleared"
      s.should have_selector "a", :onclick => "editEntry('#{@entry.id}'); return false;", :content => "Edit"
      s.should have_selector "a", :content => "Delete", "data-method" => "delete", :href => ledger_entry_path(@ledger, @entry)
    end
  end

end
