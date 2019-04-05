namespace :setup do
  desc 'Upload database.yml file.'
  task :database do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      upload! StringIO.new(File.read('config/database.yml')), "#{shared_path}/config/database.yml"
    end
  end

  namespace :setup do
    desc 'setup: copy config/master.key to shared/config'
    task :copy_linked_master_key do
      on roles(fetch(:setup_roles)) do
        sudo :mkdir, '-pv', shared_path
        upload! 'config/master.key', "#{shared_path}/config/master.key"
        sudo :chmod, '600', "#{shared_path}/config/master.key"
      end
    end
    before 'deploy:symlink:linked_files', 'setup:copy_linked_master_key'
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
end
