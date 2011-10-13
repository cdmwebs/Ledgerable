require 'spec_helper'

describe "/ledgers/graphs.html.haml" do

  before do
    @cm = mock('current_month', :img_src => 'current_month')
    @ltm = mock('last_three_months', :img_src => 'last_three_months')
    @cy = mock('current_year', :img_src => 'current_year')

    assign(:current_month, @cm)
    assign(:last_three_months, @ltm)
    assign(:current_year, @cy)
  end

  it "should have this title" do
    render
    rendered.should have_selector "h1", :content => "Graphs"
  end

  it "should have these charts" do
    view.should_receive(:chart_tag).with("current_month")
    view.should_receive(:chart_tag).with("last_three_months")
    view.should_receive(:chart_tag).with("current_year")
    render
  end

end