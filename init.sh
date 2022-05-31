rm -f tmp/pids/server.pid
bundle exec rake db:create
bundle exec rake db:migrate
rails s -p 3000 -b '0.0.0.0'