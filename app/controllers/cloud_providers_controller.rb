class CloudProvidersController < ApplicationController
  before_action :set_cloud_provider, only: [:show, :edit, :update, :destroy]

  # GET /cloud_providers
  # GET /cloud_providers.json
  def index
    @cloud_providers = CloudProvider.all
  end

  # GET /cloud_providers/1
  # GET /cloud_providers/1.json
  def show
  end

  # GET /cloud_providers/new
  def new
    @cloud_provider = CloudProvider.new
  end

  # GET /cloud_providers/1/edit
  def edit
  end

  # POST /cloud_providers
  # POST /cloud_providers.json
  def create
    @cloud_provider = CloudProvider.new(cloud_provider_params)

    respond_to do |format|
      if @cloud_provider.save
        format.html { redirect_to @cloud_provider, notice: 'Cloud provider was successfully created.' }
        format.json { render action: 'show', status: :created, location: @cloud_provider }
      else
        format.html { render action: 'new' }
        format.json { render json: @cloud_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /cloud_providers/1
  # PATCH/PUT /cloud_providers/1.json
  def update
    respond_to do |format|
      if @cloud_provider.update(cloud_provider_params)
        format.html { redirect_to @cloud_provider, notice: 'Cloud provider was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cloud_provider.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /cloud_providers/1
  # DELETE /cloud_providers/1.json
  def destroy
    @cloud_provider.destroy
    respond_to do |format|
      format.html { redirect_to cloud_providers_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_cloud_provider
      @cloud_provider = CloudProvider.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def cloud_provider_params
      params.require(:cloud_provider).permit(:name, :credentials_path, :ssh_key_path)
    end
end
