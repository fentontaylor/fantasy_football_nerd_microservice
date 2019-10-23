require_relative 'app'

require 'sinatra/activerecord'
require 'sinatra/activerecord/rake'

task(:default).clear
task default: [:spec]

task(:spec).clear

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end
rescue LoadError
end

task :console do
  exec 'irb -r irb/completion -r ./app'
end
