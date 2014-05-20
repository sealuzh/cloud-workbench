namespace :worker do
  AVAILABLE_ACTIONS = %w(status up down once exit restart)
  DEFAULT_WORKER_NUMBER = 1;

  # Example: restart all workers with 'worker:restart_all'
  AVAILABLE_ACTIONS.each do |action|
    task = "#{action}_all"
    desc "#{task} delayed_job workers 1-#{fetch(:delayed_job_workers).to_s}"
    task task do
      on roles(:app), in: :sequence, wait: 5 do
        all_workers(action)
      end
    end
  end

  # Example: start the first worker with 'worker:up[1]'
  AVAILABLE_ACTIONS.each do |task|
    desc "#{task} worker[WORKER_NUMBER] (the first worker has the number 1)"
    task task, [:worker_number] do |t, args|
      on roles(:app), in: :sequence, wait: 5 do
        worker_number = args[:worker_number] || DEFAULT_WORKER_NUMBER
        worker(task, worker_number.to_i)
      end
    end
  end

  def all_workers(task)
    num_workers = fetch(:delayed_job_workers).to_i
    num_workers.times do |worker|
      worker(task, worker.to_i + 1)
    end
  end

  def worker(task, worker_number)
    sudo "sv #{task} delayed_job#{worker_number}"
  end
end
