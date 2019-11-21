namespace :setup do
  desc 'Setup: copy config/master.key to shared/config'
  task :upload_master_key do
    on roles(:app) do
      sudo :mkdir, '-pv', shared_path
      upload! StringIO.new(File.read('config/master.key')), "#{shared_path}/config/master.key"
      sudo :chmod, '600', "#{shared_path}/config/master.key"
    end
  end

  desc 'Upload database.yml file.'
  task :upload_database_config do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read('config/database.yml')), "#{shared_path}/config/database.yml"
    end
  end

  desc 'Upload seed file.'
  task :upload_seed do
    on roles(:app) do
      execute "mkdir -p #{current_path}"
      upload! StringIO.new(File.read('db/seeds.rb')), "#{current_path}/db/seeds.rb"
    end
  end

  desc 'Seed the database.'
  task :seed do
    on roles(:app) do
      within current_path.to_s do
        with rails_env: :production do
          execute :rake, 'db:seed'
        end
      end
    end
  end

  desc 'Create the database.'
  task :create_db do
    on roles(:app) do
      within current_path.to_s do
        with rails_env: :production do
          execute :rake, 'db:create'
        end
      end
    end
  end
  desc 'Run Sidekiq.'
  task :restart do
    on roles(:app) do
      execute :sudo, :systemctl, :restart, :sidekiq
    end
  end
end
