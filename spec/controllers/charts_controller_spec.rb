require 'spec_helper'

describe ChartsController do

  describe "GET :show" do
    before do
      controller.stub!(:render)
      RestClient.should_receive(:get).with("url").and_return("url")
    end

    def do_get
      get :show, :url => "url"
    end

    it "should serve up a Google Chart" do
      controller.should_receive(:send_data).with("url")
      do_get
    end
  end

end