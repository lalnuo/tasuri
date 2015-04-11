class ApplicationController < ActionController::Base
  def init_session
     session[:household_permissions] ||= []
  end

  def can_access_household?(id)
    !session[:household_permissions].nil? && session[:household_permissions].include?(id)
  end
end
