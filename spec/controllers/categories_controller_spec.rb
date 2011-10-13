require 'spec_helper'

describe CategoriesController do

  before do
    @ledger = Factory(:ledger)
    @category = Factory(:category, :ledger => @ledger)
    controller.stub!(:parent => @ledger, :resource => @category)
    controller.stub!(:parent_path => "parent_path")
  end

  describe "GET :index" do
    def do_get
      request.env["CONTENT_TYPE"] = "application/json"
      get :index, :ledger_id => @ledger.id
    end

    it "should complain that the template doesn't exist" do
      # Seems like there should be a way to specity that the
      # request is looking for JSON. This is spec'd to error
      # out as we don't currently offer Categories#index as HTML.
      lambda{ do_get }.should raise_error
    end
  end

end
