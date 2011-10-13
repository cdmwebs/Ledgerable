require 'spec_helper'

describe "/shared/_errors.html.haml" do

  it "should have an #errors div" do
    render
    rendered.should have_selector "div", :id => "errors" do |s|
      s.should have_selector "p", :class => "list"
    end
  end

end
