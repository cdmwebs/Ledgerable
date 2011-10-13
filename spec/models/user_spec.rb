require 'spec_helper'

describe User do
  before do
    @user = Factory(:user)
  end

  it "should know about its Ledgers" do
    @user.respond_to?(:ledgers).should be_true
  end

  it "should know how much its worth today" do
    l1 = mock_model(Ledger, :todays_value => 1.0)
    l2 = mock_model(Ledger, :todays_value => 1.0)
    @user.stub!(:ledgers => [l1, l2])
    @user.todays_value.should == 2.0
  end

  it "should know its net worth" do
    l1 = Factory(:ledger)
    l2 = Factory(:ledger)
    l1.stub!(:todays_value => 1.0)
    l2.stub!(:todays_value => 1.0)
    @user.stub!(:ledgers => [l1,l2])
    @user.net_worth.should == 2.0
  end

end
