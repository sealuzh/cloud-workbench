# frozen_string_literal: true

# Abstraction for different types of MetricObservations:
# * The implementation detail which MetricObservation (e.g. nominal, ordered) should remain hidden for a client.
# * The concrete implementation is chosen based on the metric_type from the associated MetricDefinition
class MetricObservationsController < ApplicationController
  API_METHODS = [:index, :create, :import]
  before_action :authenticate_user!, except: API_METHODS
  protect_from_forgery except: API_METHODS
  helper_method :query_params

  # Currently only supports displaying the metric observation of a given metric definition
  def index
    @metric_observations = MetricObservation.with_query_params(query_params).order(:time)
    @metric_definition = MetricDefinition.find(params[:metric_definition_id])
    @execution = BenchmarkExecution.find(params[:benchmark_execution_id]) if params[:benchmark_execution_id].present?
    respond_to do |format|
      format.html { @metric_observations = @metric_observations.paginate(page: params[:page], per_page: 30); render action: 'index'}
      format.csv  { send_data MetricObservation.to_csv(@metric_observations) }
    end
  rescue => error
    flash[:error] = error.message.html_safe
    redirect_to benchmark_definitions_path
  end

  def create
    @metric_observation = MetricObservation.create!(metric_observation_params)
    success_status = 201 # created
    respond_to do |format|
      format.json { render json: @metric_observation, status: success_status }
      format.html { render json: @metric_observation, status: success_status }
    end
  rescue => error
    respond_to do |format|
      format.json { head :internal_server_error }
      format.html { render html: "Could not create metric observation. #{error.message}", status: :internal_server_error }
    end
  end

  # Bulk import
  def import
    MetricObservation.import!(metric_observation_params)
    success_status = 201 # created
    respond_to do |format|
      format.json { head success_status }
      format.html { render html: 'Metric observations successfully imported', status: success_status }
    end
  rescue => error
    respond_to do |format|
      format.json { head :internal_server_error }
      format.html { render html: "Could not import metric observations. #{error.message}", status: :internal_server_error }
    end
  end

  def query_params
    params.permit(:metric_definition_id, :benchmark_execution_id).to_h
  end

  private

    def metric_observation_params
      params.require(:metric_observation).permit(:metric_definition_id, :provider_name, :provider_instance_id, :time, :value, :file).to_h
    end
end
