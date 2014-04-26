class BenchmarkExecution < ActiveRecord::Base
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
  has_many :nominal_metric_observations
  has_many :virtual_machine_instances

  def active?
    # TODO: Implement based on new state model using symbolic values (enum) or based on end_time
    status != 'FINISHED'
  end

  def inactive?
    !active?
  end

  def duration
    if active?
      Time.now - start_time
    else
      end_time - start_time
    end
  end
end
