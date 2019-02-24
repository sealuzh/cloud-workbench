# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception, prepend: true
  before_action :authenticate_user!

  def layout_by_resource
    if devise_controller? and !user_signed_in?
      'devise'
    else
      'application'
    end
  end

  # See "Gracefully handling InvalidAuthenticityToken exceptions"
  # Phase 1 (2nd variation): https://stackoverflow.com/a/36533724/6875981
  def handle_unverified_request
    flash[:error] = 'Unverified request. Please retry or clear your cookie!'
    redirect_to :back
  end
end
