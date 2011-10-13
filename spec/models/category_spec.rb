require 'spec_helper'

describe Category do

  it "should know about associated Entries" do
    c = Category.create(:name => "Test")
    t1 = Entry.create(:category_id => c.id)
    t2 = Entry.create(:category_id => c.id)
    c.entries.should == [t1,t2]
  end

  it "should know how to order Categories" do
    c1 = Category.create(:name => "B")
    c2 = Category.create(:name => "C")
    c3 = Category.create(:name => "A")
    Category.all.should == [c3,c1,c2]
  end

  it "should know how to implement :to_json" do
    ledger = Factory(:ledger)
    category = Factory(:category, :ledger => ledger)

    res = JSON.parse(category.to_json)
    res["name"].should == category.name
    res["id"].should == category.id
    res["ledger_id"].should == ledger.id
    Date.parse(res["created_at"]).should == category.created_at.to_date
    Date.parse(res["updated_at"]).should == category.updated_at.to_date
  end

end
