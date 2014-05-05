class BenchmarkDefinitionsController < ApplicationController
  include BenchmarkDefinitionsHelper
  before_action :set_benchmark_definition, only: [:show, :edit, :update, :destroy]
  # A benchmark definition with existing executions MUST NOT be edited
  # TODO: You should be able to edit it, but showing a flash message would be nice
  before_action :ensure_integrity_of_existing_executions , only: [:edit, :update]

  # GET /benchmark_definitions
  def index
    @benchmark_definitions = BenchmarkDefinition.paginate(page: params[:page])
  end

  # GET /benchmark_definitions/1
  def show
    @benchmark_executions = @benchmark_definition.benchmark_executions.paginate(page: params[:page])
    @metric_definitions = @benchmark_definition.metric_definitions
  end

  # GET /benchmark_definitions/new
  def new
    @benchmark_definition = BenchmarkDefinition.new(vagrantfile: vagrantfile_template)
  end

  # GET /benchmark_definitions/1/edit
  def edit
    @metric_definitions = @benchmark_definition.metric_definitions
    # TODO: Implement file locking mechanism during edit. Lock must expire after N minutes.
    # See: http://stackoverflow.com/questions/1803574/rails-implementing-a-simple-lock-to-prevent-users-from-editing-the-same-data
  end

  # POST /benchmark_definitions
  def create
    @benchmark_definition = BenchmarkDefinition.new(benchmark_definition_params)

    if @benchmark_definition.save
      flash[:success] = 'Benchmark definition was successfully created.'
      redirect_to edit_benchmark_definition_path(@benchmark_definition)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /benchmark_definitions/1
  def update
    if @benchmark_definition.update(benchmark_definition_params)
      @benchmark_definition.save_vagrant_file(params[:vagrant_file_content])
      flash[:success] = 'Benchmark definition was successfully updated.'
      redirect_to edit_benchmark_definition_path(@benchmark_definition)
    else
      render action: 'edit'
    end
  end

  # DELETE /benchmark_definitions/1
  def destroy
    @benchmark_definition.destroy
      redirect_to benchmark_definitions_url
  end

  private
    def set_benchmark_definition
      @benchmark_definition = BenchmarkDefinition.find(params[:id])
    end

    def benchmark_definition_params
      params.require(:benchmark_definition).permit(:name, :vagrantfile)
    end

    def ensure_integrity_of_existing_executions
      if @benchmark_definition.benchmark_executions.any?
        flash[:error] = "You can't modify a benchmark that has already been executed!"
        redirect_to @benchmark_definition
      end
    end
end
