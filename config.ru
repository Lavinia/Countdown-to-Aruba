require "rubygems"
require "bundler"

Bundler.require

require "./app"
require "./wrapper"
run Wrapper.new(Sinatra::Application)
