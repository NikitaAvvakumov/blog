class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_to user #@current_user
    else
      flash.now[:warning] = 'Invalid email/password.'
      render 'sessions/new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
