class BenchmarkExecution < ActiveRecord::Base
  belongs_to :benchmark_definition
  validates :benchmark_definition, presence: true
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
      Time.current - start_time
    else
      end_time - start_time
    end
  end

  def prepare
    self.status = 'PREPARING'
    self.start_time = Time.current
  end
end
