# Development logging to console:
if Sinatra::Application.development?
  ActiveRecord::Base.logger = Logger.new(STDOUT)
end

# Database loading setup is required due to inheritance:
Dir[APP_ROOT.join('app', 'models', '*.rb')].each do |model_file|
  filename = File.basename(model_file).gsub('.rb', '')
  autoload ActiveSupport::Inflector.camelize(filename), model_file
end

# Setup for Heroku would normally go here. While I'm not currently planning on uploading
# this to Heroku, I suppose it won't hurt to include:
db = URI.parse(ENV['DATABASE_URL'] || "postgres://localhost/#{APP_NAME}_#{Sinatra::Application.environment}")

DB_NAME = db.path[1..-1]

# RACK_ENV will be set in the Rakefile later, but it apparently is set to :development
# automatically to begin with. Not sure when this changes.

ActiveRecord::Base.establish_connection(
  adapter: db.scheme == 'postgres' ? 'postgresql' : db.scheme,
  host: db.host,
  port: db.port,
  username: db.user,
  password: db.password,
  database: DB_NAME,
  encoding: 'utf8'
)
