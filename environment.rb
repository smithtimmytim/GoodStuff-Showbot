require 'rubygems'
require 'bundler/setup'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'dm-migrations'
require 'haml'
require 'sass'

require 'sinatra' unless defined?(Sinatra)

LIVE_URL = 'http://www.goodstuff.fm/live.json'

configure do
  # load models
  Dir.glob("#{File.dirname(__FILE__)}/lib/models/*.rb").sort.each { |lib| require lib }
end

configure(:production, :development) do
  DataMapper::Logger.new(STDOUT, :debug) if settings.development?

  current_directory = File.expand_path(File.dirname(__FILE__))
  sqlite_file = File.join(current_directory, 'db', "#{Sinatra::Base.environment}.db")
  DataMapper.setup(:default, (ENV["HEROKU_POSTGRESQL_CYAN_URL"] ||
                              "sqlite3:///#{sqlite_file}"))
  DataMapper.finalize
end

configure :test do
  puts 'Test configuration in use'
  DataMapper.setup(:default, "sqlite3::memory:")
  DataMapper.auto_migrate!
  DataMapper.finalize
end
