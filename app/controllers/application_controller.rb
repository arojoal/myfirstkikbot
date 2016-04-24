class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  protected
  def get_kik_instance
	KiK::Api.new ENV['RAILS_KIK_BOT_USERNAME'],ENV['RAILS_KIK_BOT_API_KEY']
  end

end
