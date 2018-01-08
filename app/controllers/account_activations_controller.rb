class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.active
      log_in user
      flash[:success] = t "controllers.m_success_active"
      redirect_to user
    else
      flash[:danger] = t "controllers.m_invalid_active"
      redirect_to root_url
    end
  end
end
