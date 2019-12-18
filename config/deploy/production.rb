set :stage, :production
set :rails_env, :production

server 'bida.biofiltro.com', user: 'ubuntu', roles: %w[web app db], primary: true

set :sidekiq_role, :web
set :sidekiq_env, 'production'
set :sidekiq_pid, "#{shared_path}/pids/sidekiq.pid"
set :sidekiq_log, "#{shared_path}/log/sidekiq.log"
set :sidekiq_config, -> { File.join(current_path, 'config', 'sidekiq.yml') }
