# Gem setup with bundler:
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../../Gemfile', __FILE__)

require 'bundler/setup' if File.exists?(ENV['BUNDLE_GEMFILE'])

# Gems from the gemfile:
require 'rubygems'

require 'uri'
require 'pathname'

require 'bcrypt'

require 'pg'
require 'active_record'
require 'logger'

require 'sinatra'
require 'sinatra/reloader' if development?

require 'erb'

# Setting up app constants:
APP_ROOT = Pathname.new(File.expand_path('../../', __FILE__))

APP_NAME = APP_ROOT.basename.to_s

# Setting up custom session-setter, since the root is different:
configure do
  set :root, APP_ROOT.to_path
  enable :sessions
  # Using SecureRandom hex for session secret:
  set :session_secret, ENV['SESSION_SECRET'] || '7685e6d50564e5853cb68a0f97bdb36c75b66575a5a6a42cb1659be03ffc493adf72d402fa874359437b578cb83ff5c7e8b8f79ce3c9243623c530d75a001c8d'

  # Views folder:
  set :views, File.join(Sinatra::Application.root, "app", "views")
end

# Controllers/Helpers folders:
Dir[APP_ROOT.join('app', 'controllers', '*.rb')].each { |file| require file }
Dir[APP_ROOT.join('app', 'helpers', '*.rb')].each { |file| require file }

# DB and models:
require APP_ROOT.join('config', 'database')
