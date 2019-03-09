# frozen_string_literal: true

class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!, raise: false
  skip_before_action :verify_authenticity_token
  # NOTE: Consider using a failsafe errors layout
  # layout 'errors'

  def show
    render status: status_code, template: "errors/#{status_code}", formats: [:html]
  end

  protected

    def status_code
      params[:code] || :internal_server_error # 500
    end
end
