require 'rubygems'
require 'capistrano/node-deploy'

set :application, 'emeals'
set :node_env, 'production'
set :repository, 'https://github.com/mjm/emeals-angular.git'
set :user, 'deploy'
set :use_sudo, false
set :scm, :git
set :deploy_to, "/web/apps/#{application}-#{node_env}"
set :app_command, "server.js"
set :app_environment, "PORT=6000"

role :app, "mattmoriarity.com"

after "node:install_packages", "angular:build"

namespace :angular do
  task :build do
    run "cd #{release_path} && grunt build"
  end
end
