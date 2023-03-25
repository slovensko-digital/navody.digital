class ProfilesController < ApplicationController
  before_action :require_user
  before_action :disable_feedback

  def show # shows the profile page of currently logged user
    @user_email = current_user.email
  end

  def destroy # deletes user profile
    user = current_user
    reset_session
    user.destroy
    redirect_to root_path, notice: 'Odstránenie konta bolo úspešné.'
  end
end
