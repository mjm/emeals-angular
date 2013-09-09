require 'rubygems'
require 'capistrano/node-deploy'

set :application, 'emeals'
set :node_env, 'production'
set :repository, 'https://github.com/mjm/emeals-angular.git'
set :user, 'deploy'
set :use_sudo, false
set :scm, :git
set :deploy_to, "/web/apps/#{application}-#{node_env}"
set :node_binary, "/usr/local/bin/coffee"
set :app_command, "app.coffee"
set :app_environment, "PORT=7000"

role :app, "mattmoriarity.com"
