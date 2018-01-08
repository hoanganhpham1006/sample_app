class UsersController < ApplicationController
  before_action :logged_in_user, except: %i(new create show)
  before_action :find_user_id, except: %i(index new create)
  before_action :correct_user, only: %i(edit update)
  before_action :verify_admin, only: :destroy

  def index
    @users = User.select(:id, :name, :email)
      .order(:id)
      .paginate page: params[:page],
    per_page: Settings.paginate.num_per_page
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      flash[:success] = t "controllers.m_success"
      redirect_to @user
    else
      render :new
    end

  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "controllers.update_success_mes"
      redirect_to @user
    else
      render :edit
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t "controllers.deleted_noti"
    else
      flash[:danger] = t "controllers.deleted_failed_noti"
    end
    redirect_to users_url
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = t "controllers.require_login_mes"
      redirect_to login_url
    end
  end

  def correct_user
    redirect_to root_url unless current_user.current_user? @user
  end

  def verify_admin
    redirect_to root_url unless current_user.admin?
  end

  def find_user_id
    @user = User.find_by id: params[:id]

    if @user.nil?
      flash[:danger] = t "controllers.m_nil"
      redirect_to root_path
    end
  end
end
