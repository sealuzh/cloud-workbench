# Source: http://stackoverflow.com/a/22206605

namespace :bundle do
  # Example: Run via "cap production bundle:list"
  desc 'List the installed gems'
  task :list do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "list"
        end
      end
    end
  end
end