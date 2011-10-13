class LedgersController < InheritedResources::Base
  actions :all, :except => [:index, :show]
  protect_from_forgery :except => [:update, :create, :destroy]

  def graphs
    @current_month     = MonthlyExpensesChart.new(resource, :current_month)
    @last_three_months = MonthlyExpensesChart.new(resource, :last_three_months)
    @current_year      = MonthlyExpensesChart.new(resource, :current_year)

    render :action => :graphs, :layout => "colorbox"
  end

  def payees
    render :json => resource.payees(params[:term]).to_json
  end

  def category_list
    render :json => resource.category_list(params[:term]).to_json
  end

  def last_category
    render :text => resource.last_category_for(params[:payee])
  end

end
