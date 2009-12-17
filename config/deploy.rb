set :application, 'clutterapp'


# If you aren't deploying to /u/apps/#{application} on the target servers (which is the default), you can specify the actual location via the :deploy_to variable:
#set :deploy_to, "/var/www/#{application}"


task :prod do
  set :rails_env, 'production'
  
  set :domain, 'prod.clutterapp.com'
  role :web, domain                          # Your HTTP server, Apache/etc
  role :app, domain                          # This may be the same as your `Web` server
  role :db,  domain, :primary => true # This is where Rails migrations will run
  #role :db,  'your slave db-server here'
  
  set :deploy_to, '/var/www/clutterapp'
  
  set :branch, 'master'
end

task :stag do
  set :rails_env, 'staging'
  
  set :domain, 'stag.clutterapp.com'
  role :web, domain # Your HTTP server, Apache/etc
  role :app, domain # This may be the same as your `Web` server
  role :db,  domain, :primary => true#'174.143.208.40', :primary => true # This is where Rails migrations will run
  #role :db,  "your slave db-server here"
  
  set :deploy_to, '/var/www/clutterapp-stag'
  
  set :branch, 'master'
end

set :user, 'rails' # SSH username, optional if the same as the dev computer username
set :use_sudo, false


set :repository,  'git@snaotn.6bitt.com:orgclut2.git'
set :scm, :git
set :deploy_via, :remote_cache
set :git_enable_submodules, 1

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
