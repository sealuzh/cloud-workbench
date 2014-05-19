require 'securerandom'
class BenchmarkDefinitionsController < ApplicationController
  include BenchmarkDefinitionsHelper
  before_action :set_benchmark_definition, only: [:show, :edit, :update, :destroy]
  before_action :check_and_show_executions_integrity_warning , only: [:edit, :update]

  # GET /benchmark_definitions
  def index
    @benchmark_definitions = BenchmarkDefinition.paginate(page: params[:page])
  end

  # GET /benchmark_definitions/1
  def show
    @benchmark_executions = @benchmark_definition.benchmark_executions.paginate(page: params[:page], per_page: 10)
  end

  # POST /benchmark_definitions/1
  def clone
    # TODO: write model test and push this functionality into model
    benchmark_definition_original = BenchmarkDefinition.find(params[:id])
    # Block will be called for original and each included association
    @benchmark_definition = benchmark_definition_original.dup include: [ :metric_definitions, :benchmark_schedule ] do |original, clone|
      case clone.class.name
        when 'BenchmarkDefinition'
          # Avoid name collision if copying a benchmark multiple times
          clone.name = "#{original.name} copy (#{SecureRandom.hex(1)})"
        when 'BenchmarkSchedule'
          # binding.pry
          clone.active = false if clone.present?
      end
    end
    @benchmark_definition.save!

    @metric_definitions = @benchmark_definition.metric_definitions
    render action: 'edit'
  rescue => e
    link_to_original = view_context.link_to benchmark_definition_original.name, benchmark_definition_original, class: 'alert-link'
    flash[:error] = "Benchmark definition #{link_to_original} couldn't be cloned. #{e.message}".html_safe
    redirect_to :back
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
      show_success_flash 'created'
      redirect_to edit_benchmark_definition_path(@benchmark_definition)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /benchmark_definitions/1
  def update
    @benchmark_definition.update!(benchmark_definition_params)
    show_success_flash 'updated'
    if @benchmark_definition.benchmark_executions.any?
      redirect_to @benchmark_definition
    else
      redirect_to edit_benchmark_definition_path(@benchmark_definition)
    end
  rescue => e
      render action: 'edit'
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

    def check_and_show_executions_integrity_warning
      if @benchmark_definition.benchmark_executions.any?
        flash.now[:info] = "You try to modify a benchmark that has already been executed."
      end
    end

    def show_success_flash(action)
      flash[:success] = "Benchmark definition <strong>#{view_context.link_to @benchmark_definition.name, @benchmark_definition, class: 'alert-link'}</strong> was successfully #{action}.".html_safe
    end
end
