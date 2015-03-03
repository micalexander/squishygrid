require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/puma'
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)

set :domain, 'squishygrid.com'
set :deploy_to, '/var/www/squishygrid'
set :repository, 'git@github.com:micalexander/squishygrid.git'
set :branch, 'master'
set :config, "#{deploy_to}/#{shared_path}/config/puma.rb"
set :state, "#{deploy_to}/#{shared_path}/tmp/sockets/puma.state"

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'log']

# Optional settings:
  set :user, 'micwall'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
#   set :forward_agent, true     # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  invoke :'rbenv:load'
end

# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets/"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets/"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml'."]

end

desc "Deploys the current version to the server."
task :deploy => :environment do
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    # invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      invoke :start
    end
  end
end

desc "Restart the server."
task :restart => :environment do
  in_directory "#{deploy_to}/#{current_path}" do
    queue "bundle exec pumactl -S #{state} -p 4567 restart"
  end
end

desc "Start the server."
task :start => :environment do
  in_directory "#{deploy_to}/#{current_path}" do
    queue "bundle exec puma  -q -d -e -C /var/www/squishygrid/config/puma.rb -p 4567 start"
  end
end

desc "Stop the server."
task :stop => :environment do
  in_directory "#{deploy_to}/#{current_path}" do
    queue "bundle exec pumactl -S #{state} -p 4567 stop"
  end
end

desc "Report server process id"
task :info => :environment do
  in_directory "#{deploy_to}/#{shared_path}" do
    queue "print 'Server running with pid:' `cat tmp/pids/puma.pid`"
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers

