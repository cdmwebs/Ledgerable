class EntriesController < InheritedResources::Base
  belongs_to :ledger
  layout "colorbox"

  respond_to :html, :json
  protect_from_forgery :except => [:update, :create, :destroy]

  def index
    render :json => parent.one_year_window.to_json
  end

  def create
    attributes = params[:entry].merge!({:category_id => category.id})
    @entry = parent.entries.create(attributes)
    redirect_to parent_path
  end

  def update
    @entry = parent.entries.find_by_id(params[:id])
    attributes = params[:entry].merge!({:category_id => category.id})
    @entry.update_attributes(attributes)
    redirect_to parent_path
  end

  def destroy
    resource.destroy
    render :json => resource.to_json
  end

  def cleared
    resource.cleared!
    render :json => resource.to_json
  end

  def uncleared
    resource.uncleared!
    render :json => resource.to_json
  end

  protected

  def category
    name = params[:entry].delete(:category)
    parent.categories.find_or_create_by_name(name)
  end

  def collection
    @entries ||= end_of_association_chain.all(:include => :category)
  end

end
