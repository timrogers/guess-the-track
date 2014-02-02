class ApplicationController < ActionController::Base
  before_filter :log_session

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  def log_session
    Rails.logger.info session[:correct_song]
  end
end
