class BenchmarkDefinitionsController < ApplicationController
  include BenchmarkDefinitionsHelper
  before_action :set_benchmark_definition, only: [:show, :edit, :update, :destroy]
  before_action :check_and_show_executions_integrity_warning , only: [:edit, :update]

  def index
    @benchmark_definitions = BenchmarkDefinition.search(params[:search]).paginate(page: params[:page])
  end

  def show
    @benchmark_executions = @benchmark_definition.benchmark_executions.paginate(page: params['execution_page'], per_page: 10)
    @virtual_machine_instances = @benchmark_definition.virtual_machine_instances.paginate(page: params[:page], per_page: 10)
  end

  def clone
    benchmark_definition_original = BenchmarkDefinition.find(params[:id])
    @benchmark_definition = benchmark_definition_original.clone
    @metric_definitions = @benchmark_definition.metric_definitions
    render action: 'edit'
  rescue => e
    link_to_original = view_context.link_to benchmark_definition_original.name, benchmark_definition_original, class: 'alert-link'
    flash[:error] = "Benchmark definition #{link_to_original} couldn't be cloned. #{e.message}".html_safe
    redirect_to :back
  end

  def new
    @benchmark_definition = BenchmarkDefinition.new(vagrantfile: vagrantfile_example)
  end

  def edit
  end

  def create
    @benchmark_definition = BenchmarkDefinition.new(benchmark_definition_params)

    if @benchmark_definition.save
      show_success_flash 'created'
      redirect_to edit_benchmark_definition_path(@benchmark_definition)
    else
      render action: 'new'
    end
  end

  def update
    @benchmark_definition.update!(benchmark_definition_params)
    show_success_flash 'updated'
    if @benchmark_definition.benchmark_executions.any?
      redirect_to @benchmark_definition
    else
      redirect_to edit_benchmark_definition_path(@benchmark_definition)
    end
  rescue => e
    flash[:error] = e.message
    render action: 'edit'
  end

  def destroy
    @benchmark_definition.destroy!
    redirect_to benchmark_definitions_url
  rescue => e
    flash[:error] = e.message
    redirect_to @benchmark_definition
  end

  private
    def set_benchmark_definition
      @benchmark_definition = BenchmarkDefinition.find(params[:id])
    end

    def benchmark_definition_params
      params.require(:benchmark_definition).permit(:name, :running_timeout, :vagrantfile, :provider_name)
    end

    def check_and_show_executions_integrity_warning
      if @benchmark_definition.benchmark_executions.any?
        flash.now[:info] = "You try to modify a benchmark that has already been executed."
      end
    end

    def show_success_flash(action)
      flash[:success] = "Benchmark definition <strong>#{view_context.link_to @benchmark_definition.name, @benchmark_definition, class: 'alert-link'}</strong> was successfully #{action}.".html_safe
    end

    def vagrantfile_example
      template = ERB.new File.read(Rails.application.config.vagrantfile_example)
      template.result
    end
end
