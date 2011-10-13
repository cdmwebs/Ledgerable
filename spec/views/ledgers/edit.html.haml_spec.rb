require 'spec_helper'

describe "/ledgers/edit.html.haml" do

  before do
    @ledger = Factory(:ledger)
    assign(:ledger, @ledger)
  end

  it "should have this title" do
    view.should_receive(:title).with("Edit #{@ledger}")
    render
  end

  it "should have this form" do
    render
    rendered.should have_selector "form", :action => ledger_path(@ledger) do |f|
      f.should have_selector "input", :name => "ledger[name]"
      f.should have_selector "input", :type => "submit"
    end
  end

  it "should show any errors" do
    view.should_receive(:errors)
    render
  end

end
