class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # include the SessionsHelper module to make sign-in functions within it available in other controllers
  include SessionsHelper
end
