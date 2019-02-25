# frozen_string_literal: true

class BenchmarkSchedulesController < ApplicationController
  before_action :set_benchmark_schedule, only: [:edit, :update, :activate, :deactivate]
  before_action :set_benchmark_definition, only: [:new, :create]

  def new
    @benchmark_schedule = @benchmark_definition.build_benchmark_schedule
  end

  def index
    @benchmark_schedules = BenchmarkSchedule.unscoped
    @benchmark_schedules = @benchmark_schedules.actives if params[:active].present?
    @benchmark_schedules = @benchmark_schedules.paginate(page: params[:page])
  end

  def edit
    @benchmark_definition = @benchmark_schedule.benchmark_definition
  end

  def create
    @benchmark_schedule = @benchmark_definition.build_benchmark_schedule(benchmark_schedule_params)
    @benchmark_schedule.save!
    success_flash_for 'created'
    redirect_to @benchmark_definition
  rescue => error
    flash.now[:error] = error.message
    render action: 'new'
  end

  def update
    @benchmark_definition = @benchmark_schedule.benchmark_definition
    @benchmark_schedule.update!(benchmark_schedule_params)
    success_flash_for 'updated'
    redirect_to @benchmark_definition
  rescue => error
    flash.now[:error] = error.message
    render action: 'edit'
  end

  def activate
    @benchmark_definition = @benchmark_schedule.benchmark_definition
    @benchmark_schedule.activate!
    success_flash_for 'activated'
  rescue => e
    error_flash_for('activated', e.message)
  ensure
    redirect_back(fallback_location: benchmark_definitions_path)
  end

  def deactivate
    @benchmark_definition = @benchmark_schedule.benchmark_definition
    @benchmark_schedule.deactivate!
    success_flash_for 'deactivated'
  rescue => e
    error_flash_for('deactivated', e.message)
  ensure
    redirect_back(fallback_location: benchmark_definitions_path)
  end

  private
    def set_benchmark_schedule
      @benchmark_schedule = BenchmarkSchedule.find(params[:id])
    end

    def set_benchmark_definition
      @benchmark_definition = BenchmarkDefinition.find(params[:benchmark_definition_id])
    end

    def benchmark_schedule_params
      params.require(:benchmark_schedule).permit(:benchmark_definition_id, :cron_expression, :active)
    end

    def success_flash_for(action)
      flash[:success] = "Schedule for #{view_context.alert_link(@benchmark_definition)} was successfully #{action}:
                         <strong>#{@benchmark_schedule.cron_expression}</strong> <em>(#{@benchmark_schedule.cron_expression_in_english})</em>".html_safe
    end

    def error_flash_for(action, message)
      flash[:error] = "Schedule for #{view_context.alert_link(@benchmark_definition)} couldn't be #{action}. #{message}".html_safe
    end
end
