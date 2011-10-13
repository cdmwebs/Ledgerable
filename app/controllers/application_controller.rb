class ApplicationController < ActionController::Base
  protect_from_forgery

  # This turns the layout off for every AJAX request.
  layout proc{ |c| c.request.xhr? ? false : "application" }

  helper_method :current_user

  def current_user
    @user ||= User.first
  end

end
