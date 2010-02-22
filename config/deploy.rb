set :application, 'clutterapp'



# prod
#   is for stable production server deployment
#   pulls from the "stable" branch, which follows the "master" branch
#   uses the production DB
task :prod do
  set :rails_env, 'production'
  
  set :domain, 'prod.clutterapp.com'
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
  #role :db,  'your slave db-server here'
  
  set :deploy_to, '/var/www/clutterapp'
  
  set :branch, 'stable' # don't change
end


# "edge"
#   is for near-stable production server deployment
#   pulls from the latest on the "master" branch
#   uses the production DB
task :edge do
  set :rails_env, 'production'
  
  set :domain, 'edge.clutterapp.com'
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
  #role :db,  'your slave db-server here'
  
  set :deploy_to, '/var/www/clutterapp-edge'
  
  set :branch, 'master' # don't change
end


# "stag"
#   is for experimental production or production-like server deployment
#   can be changed to pull from any branch, depending on the need
#   uses its own DB, which can be cloned from the production DB when needed
task :stag do
  set :rails_env, 'staging' # a copy of the production environment, but using a different DB
  
  set :domain, 'stag.clutterapp.com'
  role :web, domain
  role :app, domain
  role :db,  domain, :primary => true
  #role :db,  'your slave db-server here'
  
  set :deploy_to, '/var/www/clutterapp-stag'
  
  set :branch, 'sub-pile-refs' # feel free to change this per-branch
end



set :user, 'rails' # SSH username, optional if the same as the dev computer username
set :use_sudo, false


set :repository,  'git@snaotn.6bitt.com:orgclut2.git'
set :scm, :git
set :deploy_via, :remote_cache
#set :git_enable_submodules, 1

#ssh_options[:forward_agent] = true # needed?



=begin
	Passenger
=end

namespace :passenger do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

namespace :deploy do
  desc "Restart the Passenger system."
  [:start, :restart].each do |name|
    task name, :roles => :app do
      passenger.restart
    end
  end
end



=begin
  DB Backup
=end

#desc "Update the shared backups directory."
#task :symlink_backups_dir, :roles => :app do
#  run "rm -rf #{shared_path}/backups"
#  run "mv #{release_path}/project/backups #{shared_path}/"
#  run "ln -sfn #{shared_path}/backups #{release_path}/project/backups"
#end

desc "Update the database.yml config file."
task :symlink_database_config, :roles => :app do
  run "ln -sfn #{shared_path}/config/database.yml #{release_path}/config/database.yml"
end

desc "Do these tasks after you update the code"
task :after_update_code do
  #symlink_backups_dir
  symlink_database_config
end
