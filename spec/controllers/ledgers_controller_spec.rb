require 'spec_helper'

describe LedgersController do

  before do
    @ledger = Factory(:ledger)
    controller.stub!(:resource => @ledger)
  end

  describe "GET :show" do
    def do_get
      get :show, :id => 1
    end

    it "should setup @starting_value" do
      @ledger.stub!(:two_month_window_start_value => "two_month_window_start_value")
      do_get
      assigns[:starting_value].should == "two_month_window_start_value"
    end

    it "should setup @entries" do
      @ledger.stub!(:two_month_window => "two_month_window")
      do_get
      assigns[:entries].should == "two_month_window"
    end
  end

  describe "GET :edit" do
    def do_get
      get :edit, :id => 1
    end

    it "should setup @ledger" do
      do_get
      assigns[:ledger].should == @ledger
    end
  end

  describe "GET :graphs" do
    before do
      MonthlyExpensesChart.stub!(:new).with(@ledger, :current_month).and_return("current_month")
      MonthlyExpensesChart.stub!(:new).with(@ledger, :last_three_months).and_return("last_three_months")
      MonthlyExpensesChart.stub!(:new).with(@ledger, :current_year).and_return("current_year")
    end

    def do_get
      get :graphs, :id => 1
    end

    it "should setup @current_month" do
      do_get
      assigns[:current_month].should == "current_month"
    end

    it "should setup @last_three_months" do
      do_get
      assigns[:last_three_months].should == "last_three_months"
    end

    it "should setup @current_year" do
      do_get
      assigns[:current_year].should == "current_year"
    end

  end

  describe "GET :backup" do
    before do
      @ledger.stub!(:backup => "path")
      controller.stub!(:send_file)
      File.stub!(:delete)
      @ledger.should_receive(:to_qif).and_return("data")
    end

    def do_get
      get :backup, :id => 1
    end

    it "should send the backup" do
      controller.should_receive(:send_data).with("data", :type => "application/qif", :filename => "#{@ledger.name} - #{Date.today}.qif")
      do_get
    end
  end

  describe "GET :payees" do
    def do_get
      get :payees, :term => "AA", :id => 1
    end

    it "should find matching payees" do
      @ledger.should_receive(:payees).with("AA")
      do_get
    end

    it "should render some sweet, sweet JSON" do
      do_get
      response.content_type.should == "application/json"
    end
  end

  describe "GET :category_list" do
    def do_get
      get :category_list, :term => "AA", :id => 1
    end

    it "should find matching Categories" do
      @ledger.should_receive(:category_list).with("AA")
      do_get
    end

    it "should render some sweet, sweet JSON" do
      do_get
      response.content_type.should == "application/json"
    end
  end

  describe "GET :last_category" do
    before do
      category = @ledger.categories.create(:name => "Misc")
      @ledger.entries.create(:payee => "Test", :category => category)
    end

    def do_get
      get :last_category, :payee => "Test", :id => 1
    end

    it "should render the last used Category" do
      do_get
      response.body.should == "Misc"
    end
  end

end
