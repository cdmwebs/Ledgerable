class RecurringEntriesController < InheritedResources::Base
  belongs_to :ledger
  layout :false
  respond_to :json

  def create
    attributes = params[:recurring_entry].merge!({:category_id => category.id})
    @recurring_entry = parent.recurring_entries.create(attributes)
    redirect_to parent_path
  end

  def destroy
    @recurring_entry = parent.recurring_entries.find_by_id(params[:id])
    @recurring_entry.destroy()
    render :json => @recurring_entry.to_json
  end

  protected

  def category
    parent.categories.find_or_create_by_name(params[:category])
  end

end
