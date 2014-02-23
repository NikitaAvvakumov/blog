class UsersController < ApplicationController

  before_action :signed_in_user, except: [:index, :show]
  # Optional before filter to ensure that only owners can modify their profiles and posts
  #before_action :correct_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'New blogger created.'
      redirect_to @user
    else
      render 'users/new'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    name = @user.name
    email = @user.email
    bio = @user.bio
    if @user.update_attributes(user_params)
      flash[:success] = 'Blogger info updated.'
      redirect_to @user
    else
      @user.name = name
      @user.email = email
      @user.bio = bio
      render 'users/edit'
    end
  end

  def destroy
    user = User.find(params[:id])
    user.destroy
    flash[:success] = 'Blogger has been deleted.'
    redirect_to users_path
  end

  def show
    @user = User.find(params[:id])
  end

  def index
    @users = User.all
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :bio, :title, :avatar, :password, :password_confirmation)
    end

    def signed_in_user
      unless signed_in?
        flash[:warning] = 'Please sign in.'
        redirect_to signin_url
      end
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to root_url unless current_user?(@user)
    end
end
