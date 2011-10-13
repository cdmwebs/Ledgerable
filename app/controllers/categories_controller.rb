class CategoriesController < InheritedResources::Base

  belongs_to :ledger
  respond_to :html, :json
  protect_from_forgery :except => [:update, :create, :destroy]

end
