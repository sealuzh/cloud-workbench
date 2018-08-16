class ErrorsController < ApplicationController
  skip_before_action :authenticate_user!, raise: false

  def show
    render status: status, template: "errors/#{status_code}", formats: [:html]
  end

  protected

  def status_code
    params[:code] || :internal_server_error # 500
  end
end
