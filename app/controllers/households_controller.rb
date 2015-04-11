class HouseholdsController < ApplicationController
  before_filter :init_session

  def show
    household = Household.friendly.find_by_slug(params[:id])
    if household.nil?
      render :nothing => true, :status => 404
    elsif can_access_household?(params[:id])
      render :json => household
    else
      render :nothing => true, :status => 403
    end
  end

  def authenticate
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
    household = Household.create(household_params)
    session[:household_permissions] << household.name
    render :json => household
  end


  def household_params
    params.permit(:name, :password)
  end
end
