require 'sneakers'
Sneakers.configure :connection => Bunny.new(:host => ENV['RABBITMQ_HOST'])
