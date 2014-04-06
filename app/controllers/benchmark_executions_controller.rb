class BenchmarkExecutionsController < ApplicationController
  before_action :set_benchmark_execution, only: [:show, :edit, :update, :destroy]

  # GET /benchmark_executions
  # GET /benchmark_executions.json
  def index
    @benchmark_executions = BenchmarkExecution.all
  end

  # GET /benchmark_executions/1
  # GET /benchmark_executions/1.json
  def show
  end

  # GET /benchmark_executions/new
  def new
    @benchmark_execution = BenchmarkExecution.new
  end

  # GET /benchmark_executions/1/edit
  def edit
  end

  # POST /benchmark_executions
  # POST /benchmark_executions.json
  def create
    @benchmark_execution = BenchmarkExecution.new(benchmark_execution_params)

    respond_to do |format|
      if @benchmark_execution.save
        format.html { redirect_to @benchmark_execution, notice: 'Benchmark execution was successfully created.' }
        format.json { render action: 'show', status: :created, location: @benchmark_execution }
      else
        format.html { render action: 'new' }
        format.json { render json: @benchmark_execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /benchmark_executions/1
  # PATCH/PUT /benchmark_executions/1.json
  def update
    respond_to do |format|
      if @benchmark_execution.update(benchmark_execution_params)
        format.html { redirect_to @benchmark_execution, notice: 'Benchmark execution was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @benchmark_execution.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /benchmark_executions/1
  # DELETE /benchmark_executions/1.json
  def destroy
    @benchmark_execution.destroy
    respond_to do |format|
      format.html { redirect_to benchmark_executions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_benchmark_execution
      @benchmark_execution = BenchmarkExecution.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def benchmark_execution_params
      params.require(:benchmark_execution).permit(:benchmark_definition_id, :status, :start_time, :end_time)
    end
end
