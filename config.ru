require 'bundler/setup'
Bundler.require('default')
require File.dirname(__FILE__) + '/reactioner.rb'

# set :environment, :development
# # set :run, false
# # set :raise_errors, true
# set :sockets, []

map '/' do
  run CORE::Main
end
