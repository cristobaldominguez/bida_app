# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

require 'capistrano/rvm'
require 'capistrano/sidekiq'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rails/collection'
require 'capistrano/ssh_doctor'

require 'capistrano/puma'
require 'capistrano/puma/workers'
require 'capistrano/puma/nginx'
install_plugin Capistrano::Puma  # Default puma tasks
install_plugin Capistrano::Puma::Nginx  # if you want to upload a nginx site template

require 'whenever/capistrano'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

set :rvm_type, :user
set :rvm_ruby_version, '2.5.3'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
