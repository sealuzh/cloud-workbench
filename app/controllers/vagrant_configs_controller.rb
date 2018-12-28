class VagrantConfigsController < ApplicationController
  before_action :set_vagrant_config, only: [:edit, :update]

  def edit
  end

  def update
    @vagrant_config.update!(vagrant_config_params)
    flash[:success] = 'The Vagrant configuration was successfully updated.'
    redirect_to edit_vagrant_config_path
  rescue => e
    flash[:error] = e.message
    redirect_to edit_vagrant_config_path
  end

  def reset_defaults
    VagrantConfig.reset_defaults!
    flash[:success] = "The Vagrant configuration was successfully reset to its defaults."
    redirect_to edit_vagrant_config_path
  rescue => e
    flash[:error] = e.message
    redirect_to edit_vagrant_config_path
  end

  private
    def vagrant_config_params
      params.require(:vagrant_config).permit(:base_file)
    end

    def set_vagrant_config
      @vagrant_config = VagrantConfig.instance
    end
end
