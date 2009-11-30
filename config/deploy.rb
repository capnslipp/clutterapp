#############################################################
#	Application
#############################################################


set :application, 'clutterapp'



# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"



set :rails_env, 'staging'

set :branch, 'master'


set :domain, 'prod.orgclut.com'
server domain, :app, :web
role :db, domain, :primary => true

set :user, 'rails' # SSH username, optional if the same as the dev computer username
set :use_sudo, false

set :repository,  'git@snaotn.6bitt.com:orgclut2.git'
set :scm, :git
#set :scm_username, "rails"
#ssh_options[:forward_agent] = true # needed?
set :deploy_via, :remote_cache

set :git_enable_submodules, 1


#set :scm_username, "rails"
#set :scm_password, "_fill_in_"

#set :checkout, "export" # stops Capistrano from copying SVN-specific files to the app


#############################################################
#	Passenger
#############################################################

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


#############################################################
#	DB Backup
#############################################################

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
