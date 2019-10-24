require 'bundler'
Bundler.require

APP_ROOT = File.expand_path('..', __dir__)

Dir.glob(File.join(APP_ROOT, 'models', '*.rb')).each { |file| require file }

require File.join(APP_ROOT, 'config', 'database')

class App < Sinatra::Base
  set :method_override, true
  set :root, APP_ROOT
  set :public_folder, File.join(APP_ROOT, 'public')
end
