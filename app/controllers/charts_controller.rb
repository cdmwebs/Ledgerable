class ChartsController < ApplicationController

  def show
    # This is a proxy call to Google Charts so
    # that IE doesn't nag the user with SSL warnings
    url = URI.encode(params[:url])
    send_data RestClient.get url
  end

end