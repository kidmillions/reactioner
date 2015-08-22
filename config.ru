require 'bundler/setup'
require 'sinatra'
require 'haml'
require './reactioner.rb'

set :environment, :development
set :run, false
set :raise_errors, true


run Sinatra::Application
