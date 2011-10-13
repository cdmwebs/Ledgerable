require 'spec_helper'

describe MonthlyExpensesChart do

  before do
    @ledger = Factory(:ledger)
    category = Category.create(:name => "Misc")
    start_date = Date.parse("2010-01-01")
    Date.stub!(:today => Date.parse("2010-06-01"))

    (0...12).each do |i|
      curr_date = start_date + i.months

      @ledger.entries.create({
        :date        => curr_date,
        :amount      => -1.0,
        :category_id => category.id
      })
    end
  end

  it "should know how to generate a :current_month graph" do
    graph = MonthlyExpensesChart.new(@ledger, :current_month)
    graph.img_src.should == "http://chart.apis.google.com/chart?chco=0077CC&chf=bg,s,FFFFFF00&chd=s:9A&chl=Misc|Other&chtt=Current+Monthly+Expenses&cht=p3&chs=600x250&chxr=0,100.0,0.0"
  end

  it "should know how to generate a :last_three_months graph" do
    graph = MonthlyExpensesChart.new(@ledger, :last_three_months)
    graph.img_src.should == "http://chart.apis.google.com/chart?chco=0077CC&chf=bg,s,FFFFFF00&chd=s:A&chl=Other&chtt=Last+Three+Months+Expenses&cht=p3&chs=600x250&chxr=0,0.0"
  end

  it "should know how to generate a :current_year graph" do
    graph = MonthlyExpensesChart.new(@ledger, :current_year)
    graph.img_src.should == "http://chart.apis.google.com/chart?chco=0077CC&chf=bg,s,FFFFFF00&chd=s:9A&chl=Misc|Other&chtt=Current+Year+Expenses&cht=p3&chs=600x250&chxr=0,100.0,0.0"
  end

end