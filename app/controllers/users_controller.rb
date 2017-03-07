class UsersController < ApplicationController
  def edit
    @user = current_user
  end

  def update
    current_user.update! user_params
  rescue Exception => e
    render action: :edit
  end

private
  def user_params
    params.require(:user).permit(:first_name, :gender, :interested_in, :picture, :bio)
  end
end
