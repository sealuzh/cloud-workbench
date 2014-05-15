class BenchmarkDefinitionsController < ApplicationController
  include BenchmarkDefinitionsHelper
  before_action :set_benchmark_definition, only: [:show, :edit, :update, :destroy]
  before_action :set_metric_definitions, only: [:show, :edit, :update]
  before_action :check_and_show_executions_integrity_warning , only: [:edit, :update]

  # GET /benchmark_definitions
  def index
    @benchmark_definitions = BenchmarkDefinition.paginate(page: params[:page])
  end

  # GET /benchmark_definitions/1
  def show
    @benchmark_executions = @benchmark_definition.benchmark_executions.paginate(page: params[:page])
  end

  # GET /benchmark_definitions/new
  def new
    @benchmark_definition = BenchmarkDefinition.new(vagrantfile: vagrantfile_template)
  end

  # GET /benchmark_definitions/1/edit
  def edit
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
      flash[:success] = 'Benchmark definition was successfully updated.'
      if @benchmark_definition.benchmark_executions.any?
        redirect_to @benchmark_definition
      else
        redirect_to edit_benchmark_definition_path(@benchmark_definition)
      end
    else
      flash.now[:error] = "Benchmark definition couldn't be updated."
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

    def set_metric_definitions
      @metric_definitions = @benchmark_definition.metric_definitions
    end

    def check_and_show_executions_integrity_warning
      if @benchmark_definition.benchmark_executions.any?
        flash.now[:info] = "You try to modify a benchmark that has already been executed."
      end
    end
end
