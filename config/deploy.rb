require 'bundler/capistrano'

if ENV['TARGET_HOST'].nil? || ENV['TARGET_HOST'].empty?
  raise "ERROR: TARGET_HOST must be specified" 
else
  master = "slug.#{ENV['TARGET_HOST']}"
end

if ENV['TARGET_USER'].nil? || ENV['TARGET_USER'].empty?
  raise "ERROR: TARGET_USER must be specified" 
else
  set :user, ENV['TARGET_USER']
end

set :application, 'docket'
set :repository,  'kwhite@krypnos.net:projects/ruby-docket.git'
set :rails_env, 'integration'
set :deploy_to, '/data/slug'
set :deploy_via, :remote_cache
set :use_sudo, false
set :keep_releases, 3
set :branch, 'capistrano'
set :default_environment, {
  'LANG' => 'en_US.UTF-8',
  'LC_ALL' => 'en_US.UTF-8',
  'LANGUAGE' => 'en_US.UTF-8'
}

ssh_options[:forward_agent] = true
default_run_options[:pty] = true

role :web, master
role :app, master
role :db, master, :primary => true

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  task :cold do
    update
    setup_db
    start
  end

  task :setup_db, :roles => :app do
    run "cd #{current_path}; rake RAILS_ENV=#{rails_env} db:setup"
  end
end

require './config/boot'
