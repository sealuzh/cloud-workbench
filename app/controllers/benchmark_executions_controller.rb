class BenchmarkExecutionsController < ApplicationController
  PRIORITY_HIGH = 1
  API_METHODS = [:prepare_log, :release_resources_log]
  before_action :authenticate_user!, except: API_METHODS
  before_action :set_benchmark_definition, only: [:new, :create]
  before_action :set_benchmark_execution, except: [:index, :new, :create, ]

  def index
    if params[:context] == :benchmark_definition
      set_benchmark_definition
      @benchmark_executions = @benchmark_definition.benchmark_executions.paginate(page: params[:page])
    else
      @benchmark_executions = BenchmarkExecution.paginate(page: params[:page])
    end
  end

  def show
    @benchmark_definition = @benchmark_execution.benchmark_definition
    @virtual_machine_instances = @benchmark_execution.virtual_machine_instances
  end

  def toggle_keep_alive
    @benchmark_execution.update_attributes!({keep_alive: params[:keep_alive].to_bool})
    flash[:success] = "Successfully #{@benchmark_execution.keep_alive? ? 'enabled' : 'disabled'} the keep alive flag."
  rescue => e
    flash[:error] = "Could not set the keep alive flage to #{params[:keep_alive]}. #{e.message}"
  ensure
    redirect_to @benchmark_execution
  end

  def reprovision
    Delayed::Job.enqueue(ReprovisionBenchmarkExecutionJob.new(@benchmark_execution.id), PRIORITY_HIGH)
    flash[:success] = "Successfully started a reprovisioning job asynchronously."
    redirect_to @benchmark_execution
  end

  def restart_benchmark
    Delayed::Job.enqueue(StartBenchmarkExecutionJob.new(@benchmark_execution.id), PRIORITY_HIGH)
    flash[:success] = "Successfully started a restart benchmark job asynchronously."
    redirect_to @benchmark_execution
  end

  def abort
    Delayed::Job.enqueue(ReleaseResourcesJob.new(@benchmark_execution.id), PRIORITY_HIGH)
    flash[:success] = "Successfully started a release resources job asynchronously."
    redirect_to @benchmark_execution
  end

  def prepare_log
    respond_to do |format|
      format.text { render(text: @benchmark_execution.prepare_log) }
    end
  end

  def release_resources_log
    respond_to do |format|
      format.text { render(text: @benchmark_execution.release_resources_log) }
    end
  end

  def new
    @benchmark_execution = @benchmark_definition.benchmark_executions.build
  end

  def create
    @benchmark_execution = @benchmark_definition.start_execution_async
    flash[:success] = "Benchmark execution for
                       #{view_context.link_to @benchmark_definition.name, @benchmark_definition, class: 'alert-link'}
                       was successfully started asynchronously.".html_safe
    redirect_to @benchmark_execution
  rescue => e
    flash[:error] = "Benchmark execution couldn't be started asynchronously.<br>
                     #{fa_icon 'times'}. Error: #{e.message}".html_safe
    redirect_to :back
  end

  def destroy
    @benchmark_execution.destroy
      redirect_to benchmark_definitions_path
  end

  private
    def set_benchmark_definition
      @benchmark_definition = BenchmarkDefinition.find(params[:benchmark_definition_id])
    end

    def set_benchmark_execution
      @benchmark_execution = BenchmarkExecution.find(params[:id])
    end

    def benchmark_execution_params
      params.require(:benchmark_execution).permit(:benchmark_definition_id)
    end
end
