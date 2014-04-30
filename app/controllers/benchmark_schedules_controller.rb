class BenchmarkSchedulesController < ApplicationController
  before_action :set_benchmark_schedule, only: [:edit, :update]
  before_action :set_benchmark_definition, only: [:new, :create]

  def new
    @benchmark_schedule = @benchmark_definition.build_benchmark_schedule
  end

  def edit
    @benchmark_definition = @benchmark_schedule.benchmark_definition
  end

  def create
    @benchmark_schedule = @benchmark_definition.build_benchmark_schedule(benchmark_schedule_params)
    if @benchmark_schedule.save
      flash_for 'created'
      redirect_to @benchmark_definition
    else
      render action: 'new'
    end
  end

  def update
    @benchmark_definition = @benchmark_schedule.benchmark_definition
    if @benchmark_schedule.update(benchmark_schedule_params)
      flash_for 'updated'
      redirect_to @benchmark_definition
    else
      render action: 'edit'
    end
  end

  private
    def set_benchmark_schedule
      @benchmark_schedule = BenchmarkSchedule.find(params[:id])
    end

    def set_benchmark_definition
      @benchmark_definition = BenchmarkDefinition.find(params[:benchmark_definition_id])
    end

    def benchmark_schedule_params
      params.require(:benchmark_schedule).permit(:benchmark_definition_id, :crontab, :active)
    end

    def flash_for(action)
      flash[:success] = "Schedule for #{@benchmark_definition.name} was successfully #{action}:<br>
                         #{@benchmark_schedule.crontab} <i class='fa fa-arrow-right'></i>
                         #{@benchmark_schedule.crontab_in_english}".html_safe
    end
end
