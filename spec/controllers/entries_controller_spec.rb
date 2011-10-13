require 'spec_helper'

describe EntriesController do

  before do
    @ledger   = Factory(:ledger)
    @entry    = Factory(:entry, :ledger => @ledger)
    @category = Factory(:category, :ledger => @ledger, :name => "Misc")
    controller.stub!(:parent => @ledger, :resource => @entry)
    controller.stub!(:parent_path => "parent_path")
  end

  describe "POST :create" do
    def do_post
      post :create, :entry => {:payee => "Test", :category => "Misc"}, :ledger_id => 1
    end

    before do
      @ledger.entries.stub!(:create => @entry)
    end

    it "should create a new Entry" do
      lambda{ do_post }.should change(@ledger.entries, :count).by(1)
      @ledger.entries.reload
      @ledger.entries.last.category.should == @category
      @ledger.entries.last.payee.should == "Test"
    end

    it "should redirect to the root_path" do
      do_post
      response.should redirect_to "parent_path"
    end

  end

  describe "PUT :update" do
    before do
      @c1 = @ledger.categories.create(:name => "ABC")
      @c2 = @ledger.categories.create(:name => "DEF")
      @entry.update_attribute(:category_id, @c1.id)

      @ledger.entries.stub!(:find_by_id => @entry)
    end

    def do_put
      put :update, :id => @entry.id, :entry => {:category => "DEF"}, :ledger_id => @ledger.id
    end

    it "should update a Entry" do
      lambda{ do_put }.should change(@entry, :category_id).to(@c2.id)
    end

    it "should redirect to the root_path" do
      do_put
      response.should redirect_to "parent_path"
    end
  end

  describe "DELETE :destroy" do
    def do_delete
      delete :destroy, :id => 1, :ledger_id => 1
    end

    it "should destroy the Entry" do
      lambda{ do_delete }.should change(@ledger.entries, :size).by(-1)
    end

    it "should redirect_to the parent_path" do
      do_delete
      response.should redirect_to "parent_path"
    end

  end

  describe "POST :cleared" do
    def do_post
      post :cleared, :id => 1, :ledger_id => 1
    end

    it "should confirm the Entry" do
      @entry.should_receive(:cleared!)
      do_post
    end

    it "should render nothing" do
      do_post
      response.body.should == " "
    end
  end

  describe "POST :uncleared" do

    def do_post
      post :uncleared, :id => 1, :ledger_id => 1
    end

    it "should unconfirm the Entry" do
      @entry.should_receive(:uncleared!)
      do_post
    end

    it "should render nothing" do
      do_post
      response.body.should == " "
    end
  end

end
