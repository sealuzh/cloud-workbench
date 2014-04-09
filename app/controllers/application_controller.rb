class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception # TODO: SECURITY! Enable CSRF protection when authentication available
  protect_from_forgery with: :null_session
end
