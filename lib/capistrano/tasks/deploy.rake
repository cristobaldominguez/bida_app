namespace :deploy do
  desc 'Makes sure local git is in sync with remote. --> Se verifica si son las mismas versiones'
  task :check_revision do
    unless `git rev-parse HEAD` == `git rev-parse origin/master`
      puts 'WARNING: HEAD is not the same as origin/master'
      puts 'Run `git push` to sync changes.'
      exit
    end
  end

  desc 'Initial Deploy --> Aquí se hace el deploy'
  task :initial do
    on roles(:app) do
      before 'deploy:restart', 'puma:start'
      invoke 'deploy'
    end
  end

  desc 'Restart application -> Aquí se reinicia la aplicación'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke 'puma:restart'
    end
  end

  before :deploy,     'deploy:check_revision'
  after  :finishing,  'deploy:compile_assets'
  after  :finishing,  'deploy:cleanup'
end
