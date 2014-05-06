class MetricDefinitionsController < ApplicationController
  before_action :set_metric_definition, only: [:show, :edit, :update, :destroy]
  before_action :set_benchmark_definition, only: [:new, :create]
  before_action :check_and_show_observations_integrity_warning , only: [:edit, :update]

  # GET /metric_definitions/1
  def show
    @metric_observations = MetricObservation.where(metric_definition_id: @metric_definition.id)
                                            .paginate(page: params[:page])
  end

  # GET benchmark_definitions/1/metric_definitions/new
  def new
    @metric_definition = @benchmark_definition.metric_definitions.build
  end

  # GET /metric_definitions/1/edit
  def edit
  end

  # POST benchmark_definitions/1/metric_definitions
  def create
    @metric_definition = @benchmark_definition.metric_definitions.build(metric_definition_params)

    if @metric_definition.save
      flash[:success] = "Metric definition #{view_context.link_to @metric_definition.name, edit_metric_definition_path(@metric_definition)}
                         was successfully created.".html_safe
      redirect_to edit_benchmark_definition_path(@metric_definition.benchmark_definition)
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /metric_definitions/1
  def update
    if @metric_definition.update(metric_definition_params)
      flash[:success] = "Metric definition #{view_context.link_to @metric_definition.name, edit_metric_definition_path(@metric_definition)}
                         was successfully updated.".html_safe
      redirect_to @metric_definition.benchmark_definition
    else
      render action: 'edit'
    end
  end

  # DELETE /metric_definitions/1
  def destroy
    @metric_definition.destroy
    redirect_to metric_definitions_url
  end

  private

    def set_benchmark_definition
      @benchmark_definition = BenchmarkDefinition.find(params[:benchmark_definition_id])
    end

    def set_metric_definition
      @metric_definition = MetricDefinition.find(params[:id])
    end

    def metric_definition_params
      params.require(:metric_definition).permit(:benchmark_definition_id, :name, :unit, :scale_type)
    end

    def check_and_show_observations_integrity_warning
      if @metric_definition.has_any_observations?
        flash.now[:info] = "You try to modify a metric definition that already has observed values."
      end
    end
end
