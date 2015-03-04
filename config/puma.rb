root = "#{Dir.getwd}"

bind "unix://#{root}/../shared/tmp/puma/socket"
pidfile "#{root}/../shared/tmp/puma/pid"
state_path "#{root}/../shared/tmp/puma/state"
rackup "#{root}/config.ru"

threads 4, 8

activate_control_app
