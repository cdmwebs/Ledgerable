require 'spec_helper'

describe "/entries/edit.html.haml" do

  before do
    @ledger = Factory(:ledger)
    @category = Category.create(:name => "Test")
    @entry = @ledger.entries.create(:payee => "Test", :category => @category)
    assign(:entry, @entry)
    assign(:ledger, @ledger)
  end

  it "should have this title" do
    render
    rendered.should have_selector "h1", :content => "Edit Entry"
  end

  it "should have this form" do
    render
    rendered.should have_selector "form", :action => ledger_entry_path(@ledger, @entry) do |s|
      s.should have_selector "input", :name => "entry[date]"
      s.should have_selector "input", :name => "entry[payee]"
      s.should have_selector "input", :name => "entry[memo]"
      s.should have_selector "input", :name => "entry[amount]"
      s.should have_selector "select", :name => "entry[status]"
      s.should have_selector "input", :name => "entry[category]"
      s.should have_selector "input", :type => "submit"
    end
  end

  it "should show any errors" do
    view.should_receive(:errors)
    render
  end

end
