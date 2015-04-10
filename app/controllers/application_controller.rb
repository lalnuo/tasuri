class ApplicationController < ActionController::Base
  def init_session
     session[:household_permissions] ||= []
  end
end
