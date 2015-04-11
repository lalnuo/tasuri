class UsersController < ApplicationController
  def create
    user = User.create(:household_id => params[:household_id], :name => params[:name])
    if user.valid?
      render :json => user
    else
      render :nothing => true, :status => 400
    end
  end

  def user_params
    params.permit(:household_id, :username)
  end
end
