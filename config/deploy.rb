# config valid only for current version of Capistrano
lock '3.8.2'

# set :rvm_type,                  :user
# set :rvm_ruby_version,          '2.5.3'

set :user,                      'ubuntu'
set :application,               'bida_app'
set :deploy_to,                 "/home/#{fetch(:user)}/apps/#{fetch(:application)}"
set :repo_url,                  'git@bitbucket.org:cristobaldominguez/bida_app.git'
set :keep_releases,             4
set :ssh_options,               forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/biofiltro.pem]
set :rails_env,                 :production

## Linked Files & Directories (Default None):
set :linked_files,              %w[config/database.yml config/master.key]
set :linked_dirs,               %w[log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads]

set :puma_threads,              [4, 16]
set :puma_workers,              0

# Don't change these unless you know what you're doing
set :use_sudo,                  false
set :puma_bind,                 "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,                "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,                  "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log,           "#{release_path}/log/puma.access.log"
set :puma_error_log,            "#{release_path}/log/puma.error.log"
set :puma_preload_app,          true
set :puma_worker_timeout,       nil
set :puma_init_active_record,   true

set :assets_roles, %i[web app]
