require 'spec_helper'

describe "/ledgers/index.html.haml" do

  before do
    @ledger = Factory(:ledger)
    @ledger.stub!(:todays_value => 1.0)
    assign(:ledgers, [@ledger])

    @user = Factory(:user)

    @user.stub!(:todays_value => 2.0, :net_worth => 3.0)
    view.stub!(:current_user => @user)

    @chart = mock("chart", :img_src => "src", :tip => "tip")
  end

  it "should have this title" do
    render
    rendered.should have_selector "h1", :content => "My Ledgers"
  end

  it "should show the ledgers" do
    render
    rendered.should have_selector "a", :href => ledger_path(@ledger)
  end

  it "should show today's value of the Ledger" do
    render
    rendered.should contain "$1.00"
  end

  it "should show the current net worth" do
    render
    rendered.should contain "$3.00"
  end

  context "when the current user has Ledgers available" do
    before do
      @user.stub!(:ledgers_available? => true)
    end

    it "should have a new link" do
      render
      rendered.should have_selector "a", :href => new_ledger_path
    end
  end

end
