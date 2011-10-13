require 'spec_helper'

describe "/ledgers/new.html.haml" do

  before do
    assign(:ledger, Ledger.new)
    view.should_receive(:current_user).and_return(Factory(:user))
  end

  it "should have this title" do
    render
    rendered.should have_selector "h1", :content => "Add Ledger"
  end

  it "should have this form" do
    render
    rendered.should have_selector "form", :action => ledgers_path, :enctype => "multipart/form-data" do |f|
      f.should have_selector "input", :name => "ledger[name]"
      f.should have_selector "input", :name => "ledger[user_id]", :type => "hidden"
      f.should have_selector "input", :type => "submit"
    end
  end

  it "should show any errors" do
    view.should_receive(:errors)
    render
  end

end
