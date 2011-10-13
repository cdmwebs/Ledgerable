require 'spec_helper'

describe RecurringentriesController do

  before do
    @ledger = Factory(:ledger)
    @category = Factory(:category, :ledger => @ledger)
    @recurring_entry = Factory(:recurring_entry, :ledger => @ledger)
    controller.stub!(:category => @category, :parent => @ledger, :resource => @recurring_entry)
    controller.stub!(:parent_path => "parent_path", :resource_path => "resource_path")

    @opts = Factory.attributes_for(:recurring_entry).stringify_keys
  end

  describe "POST :create" do
    def do_post
      post :create, :recurring_entry => @opts, :ledger_id => 1
    end

    it "should create a new Entry" do
      lambda{ do_post }.should change(@ledger.recurring_entries, :count).by(1)
      @ledger.entries.reload
    end

    it "should redirect to the root_path" do
      do_post
      response.should redirect_to "resource_path"
    end
  end

  describe "PUT :update" do
    before do
      @c1 = @ledger.categories.create(:name => "ABC")
      @c2 = @ledger.categories.create(:name => "DEF")
      @recurring_entry.update_attribute(:category_id, @c1.id)

      @ledger.recurring_entries.stub!(:find_by_id => @recurring_entry)
    end

    def do_put
      put :update, :id => 1, :recurring_entry => {}, :category => "DEF", :ledger_id => 1
    end

    it "should update a Entry" do
      lambda{ do_put }.should change(@recurring_entry, :category_id).to(@category.id)
    end

    it "should redirect to the root_path" do
      do_put
      response.should redirect_to "resource_path"
    end
  end

end
