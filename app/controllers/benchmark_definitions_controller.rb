class BenchmarkDefinitionsController < ApplicationController
  before_action :set_benchmark_definition, only: [:show, :edit, :update, :destroy]

  # GET /benchmark_definitions
  # GET /benchmark_definitions.json
  def index
    @benchmark_definitions = BenchmarkDefinition.all
    @benchmark_execution = @benchmark_definitions.first.benchmark_executions.build
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
    # TODO: Implement file locking mechanism during edit. Lock must expire after N minutes.
    # See: http://stackoverflow.com/questions/1803574/rails-implementing-a-simple-lock-to-prevent-users-from-editing-the-same-data
    params[:vagrant_file_content] = @benchmark_definition.vagrant_file_content
  end

  # POST /benchmark_definitions
  # POST /benchmark_definitions.json
  def create
    @benchmark_definition = BenchmarkDefinition.new(benchmark_definition_params)

    respond_to do |format|
      if @benchmark_definition.save
        @benchmark_definition.save_vagrant_file(params[:vagrant_file_content]) # TODO: Error handling
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
        @benchmark_definition.save_vagrant_file(params[:vagrant_file_content]) # TODO: Error handling and ensure that only possible if benchmark has no BenchmarkExecutions
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

    def benchmark_definition_params
      params.require(:benchmark_definition).permit(:name, :vagrant_file_content)
    end
end
