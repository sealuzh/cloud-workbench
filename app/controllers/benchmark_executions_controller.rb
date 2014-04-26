class BenchmarkExecutionsController < ApplicationController
  before_action :set_benchmark_definition, only: [:new, :create]
  before_action :set_benchmark_execution, only: [:show, :edit, :update, :destroy]

  # GET /benchmark_definition/:id/benchmark_executions
  # GET /benchmark_executions
  def index
    if params[:context] == :benchmark_definition
      set_benchmark_definition
      @benchmark_executions = @benchmark_definition.benchmark_executions
    else
      @benchmark_executions = BenchmarkExecution.all
    end
  end

  # GET /benchmark_executions/1
  def show
  end

  # GET /benchmark_definition/:id/benchmark_executions/new
  def new
    @benchmark_execution = @benchmark_definition.benchmark_executions.build
  end

  # GET /benchmark_executions/1/edit
  def edit
  end

  # POST /benchmark_executions
  def create
    @benchmark_execution = @benchmark_definition.benchmark_executions.build(benchmark_execution_params)
    if @benchmark_execution.save
      Delayed::Job.enqueue(PrepareBenchmarkExecutionJob.new(@benchmark_execution.benchmark_definition_id, @benchmark_execution.id))
      redirect_to @benchmark_execution, notice: 'Benchmark execution was successfully scheduled.'
    else
      render action: 'new'
    end
  rescue => e
    flash.now[:error] = "Benchmark execution couldn't be scheduled. Error: #{e.message}"
  end

  # PATCH/PUT /benchmark_executions/1
  def update
    if @benchmark_execution.update(benchmark_execution_params)
      redirect_to @benchmark_execution, notice: 'Benchmark execution was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /benchmark_executions/1
  def destroy
    @benchmark_execution.destroy
      redirect_to benchmark_executions_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_benchmark_definition
      @benchmark_definition = BenchmarkDefinition.find(params[:benchmark_definition_id])
    end

    def set_benchmark_execution
      @benchmark_execution = BenchmarkExecution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def benchmark_execution_params
      params.require(:benchmark_execution).permit(:benchmark_definition_id, :status, :start_time, :end_time)
    end
end
