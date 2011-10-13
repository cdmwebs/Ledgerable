require 'spec_helper'

describe Date do

  it "should know how to range the last thirty days" do
    range = Date.last_thirty_days
    range.first.should == 1.month.ago.to_date
    range.last.should == Date.today
  end

end