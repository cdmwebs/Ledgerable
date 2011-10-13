require 'spec_helper'

describe "/layouts/application.html.haml" do

  it "should have this title" do
    render
    rendered.should have_selector "a", :href => "/ledgers" do |s|
      s.should have_selector "h1", :content => "Ledgerable"
    end
  end

  it "should have a .notice div" do
    render
    rendered.should have_selector "div", :class => "notice"
  end

  it "should have a .alert div" do
    render
    rendered.should have_selector "div", :class => "alert"
  end

  it "should have a link to the ledgers" do
    render
    rendered.should have_selector "a", :href => ledgers_path
  end

end
