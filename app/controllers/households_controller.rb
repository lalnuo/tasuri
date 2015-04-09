class HouseholdsController < ApplicationController
  def can_access_household?(id)
    puts session[:household_permissions]
    !session[:household_permissions].nil? && session[:household_permissions].include?(id)
  end

  def show
    if can_access_household?(params[:id])
      render :json => Household.friendly.find(params[:id])
    else
      render :nothing => true, :status => 403
    end
  end

  def authenticate
    puts session[:household_permissions]
    session[:household_permissions] = [] if !session[:household_permissions]
    household = Household.friendly.find(params[:name])
    if household && household.authenticate(params[:password])
      session[:household_permissions] << household.name if !session[:household_permissions].include? household.name
      render :json => true
    else
      render :json => false
    end
  end

  def index
    render :json => Household.all
  end

  def create
    render :json => Household.create(household_params)
  end


  def household_params
    params.require(:household).permit(:name)
  end
end
