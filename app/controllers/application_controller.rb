class ApplicationController < ActionController::Base
  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def log_session
    Rails.logger.info session[:correct_song]
  end
end
