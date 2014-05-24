class MetricDefinitionsController < ApplicationController
  before_action :set_metric_definition, only: [:edit, :update, :destroy]
  before_action :set_benchmark_definition, only: [:new, :create]
  before_action :check_and_show_observations_integrity_warning , only: [:edit, :update]

  def new
    @metric_definition = @benchmark_definition.metric_definitions.build
  end

  def edit
  end

  def create
    @metric_definition = @benchmark_definition.metric_definitions.build(metric_definition_params)
    if @metric_definition.save
      success_flash 'created'
      redirect_to :back
    else
      render action: 'new'
    end
  end

  def update
    if @metric_definition.update(metric_definition_params)
      success_flash 'updated'
      redirect_to @metric_definition.benchmark_definition
    else
      render action: 'edit'
    end
  end

  def destroy
    @metric_definition.destroy
    redirect_to :back
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

    def success_flash(action)
      flash[:success] = "Metric definition #{view_context.link_to @metric_definition.name, edit_metric_definition_path(@metric_definition), class: 'alert-link' }
                         was successfully created.".html_safe
    end
end
