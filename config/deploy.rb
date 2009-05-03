#############################################################
#	Application
#############################################################

set :application, "orgclut2"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/#{application}"


#############################################################
#	Settings
#############################################################



#############################################################
#	Servers
#############################################################

set :user, "rails" # SSH username, optional if the same as the dev computer username

set :domain, "orgclut2.slippyd.com"
server domain, :app, :web
role :db, domain, :primary => true


#############################################################
#	Subversion
#############################################################

set :repository,  "http://svn.6bitt.com/orgclut2/trunk"

# If you aren't using Subversion to manage your source code, specify
# your SCM below:
# set :scm, :subversion
set :scm_username, "slippyd"
set :scm_password, "_fill_in_"

set :checkout, "export" # stops Capistrano from copying SVN-specific files to the app


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

desc "Update the shared backups directory."
task :symlink_backups_dir, :roles => :app do
  run "rm -rf #{shared_path}/backups"
  run "mv #{release_path}/project/backups #{shared_path}/''"
  run "ln -sfn #{shared_path}/backups #{release_path}/project/backups"
end

desc "Do these tasks after you update the code"
task :after_update_code do
  symlink_backups_dir
end