class BenchmarkDefinitionsController < ApplicationController
  before_action :set_benchmark_definition, only: [:show, :edit, :update, :destroy]

  # GET /benchmark_definitions
  # GET /benchmark_definitions.json
  def index
    @benchmark_definitions = BenchmarkDefinition.all
  end

  # GET /benchmark_definitions/1
  # GET /benchmark_definitions/1.json
  def show
  end

  # GET /benchmark_definitions/new
  def new
    @benchmark_definition = BenchmarkDefinition.new
  end

  # GET /benchmark_definitions/1/edit
  def edit
  end

  # POST /benchmark_definitions
  # POST /benchmark_definitions.json
  def create
    @benchmark_definition = BenchmarkDefinition.new(benchmark_definition_params)

    respond_to do |format|
      if @benchmark_definition.save
        format.html { redirect_to @benchmark_definition, notice: 'Benchmark definition was successfully created.' }
        format.json { render action: 'show', status: :created, location: @benchmark_definition }
      else
        format.html { render action: 'new' }
        format.json { render json: @benchmark_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /benchmark_definitions/1
  # PATCH/PUT /benchmark_definitions/1.json
  def update
    respond_to do |format|
      if @benchmark_definition.update(benchmark_definition_params)
        format.html { redirect_to @benchmark_definition, notice: 'Benchmark definition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @benchmark_definition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /benchmark_definitions/1
  # DELETE /benchmark_definitions/1.json
  def destroy
    @benchmark_definition.destroy
    respond_to do |format|
      format.html { redirect_to benchmark_definitions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_benchmark_definition
      @benchmark_definition = BenchmarkDefinition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def benchmark_definition_params
      params.require(:benchmark_definition).permit(:name)
    end
end
