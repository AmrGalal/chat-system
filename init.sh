sleep 10
rm -f tmp/pids/server.pid
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake environment elasticsearch:import:model CLASS='Message'
rails s -p 3000 -b '0.0.0.0'