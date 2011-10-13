require 'spec_helper'

describe SearchesController do

  before do
    @ledger = Factory(:ledger)
  end

  describe "GET :show" do
    def do_get
      get :show, :ledger_id => @ledger.id
    end

    it "should setup @ledger" do
      do_get
      assigns[:ledger].should == @ledger
    end
  end

  describe "POST :create" do
    before do
      @user = Factory(:user)
      Ledger.should_receive(:find_by_id).with(@ledger.id.to_s).and_return(@ledger)
    end

    def do_post
      post :create, :search => {:payee => "Test"}, :ledger_id => @ledger.id
    end

    it "should search the ledger" do
      @ledger.should_receive(:search).with({"payee" => "Test"})
      do_post
    end

    it "should setup @entries" do
      do_post
      assigns[:entries].should == []
    end

    it "should setup @ledger" do
      do_post
      assigns[:ledger].should == @ledger
    end
  end

end
