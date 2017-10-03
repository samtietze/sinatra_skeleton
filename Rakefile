require 'rake'

require ::File.expand_path('../config/environment', __FILE__)

# This is where AR's class extensions come into play (camel-casing the classes, etc):
require 'active_support/core_ext'

namespace :generate do
  desc "Generating an empty model for a Class in the app/models folder"
  task :model do
    unless ENV.has_key?('NAME')
      raise "Specify the name of the model with the following syntax: rake generate:model NAME=User"
    end

    model_name      = ENV['NAME'].camelize
    model_filename  = ENV['NAME'].underscore + '.rb'
    model_path = APP_ROOT.join('app', 'models', model_filename)

    if File.exist?(model_path)
      raise "Error: This model file already exists: '#{model_path}'"
    end

    puts "Generating #{model_path}"
    File.open(model_path, 'w+') do |f|
      f.write(<<-EOF.strip_heredoc)
        class #{model_name} < ApplicationRecord
        end
      EOF
    end
  end

  desc "Generate an empty migration in the db/migrate folder"
  task :migration do
    unless ENV.has_key?('NAME')
      raise "Specify the name of the migration with the following syntax: rale generate:migration NAME=create_users"
    end

    name      = ENV['NAME'].camelize
    filename  = "%s_%s.rb" % [Time.now.strftime('%Y%m%d%H%M%S'), ENV['NAME'].underscore]
    path      = APP_ROOT.join('db', 'migrate', filename)

    if File.exist?(path)
      raise "Error: this migration already exists: '#{path}'"
    end

    puts "Creating #{path}"
    File.open(path, 'w+') do |f|
      f.write(<<-EOF.strip_heredoc)
        class #{name} < ActiveRecord::Migration[5.1]
          def change
          end
        end
      EOF
    end
  end

  desc "Create an empty model spec in spec with rake generate:spec NAME=user"
  task :spec do
    unless ENV.has_key?('NAME')
      raise "Specify the migration name! Ex: rake generate:spec NAME=user"
    end

    name      = ENV['NAME'].camelize
    filename  = "%s_spec.rb" % ENV['NAME'].underscore
    path      = APP_ROOT.join('spec', filename)

    if File.exist?(path)
      raise "Error: this model already exists at #{path}"
    end

    puts "Creating #{path}"
    File.open(path, 'w+') do |f|
      f.write(<<-EOF.strip_heredoc)
        require 'spec_helper'

        describe #{name} do
          pending "add some examples to/delete from #{__FILE__}"
        end
      EOF
    end
  end

end

namespace :db do
  desc "Drop, create, and migrate the db (don't be lazy tho)."
  task :reset => [:drop, :create, :migrate]

  desc "Create the database at #{DB_NAME}"
  task :create do
    puts "Creating dev and test dbs if they don't exist."
    system("createdb #{APP_NAME}_development && createdb #{APP_NAME}_test")
  end

  desc "Drop the table at #{DB_NAME}! Don't drop the table!"
  task :drop do
    puts "Dropping the entire carton of eggs on the kitchen floor"
    system("dropdb #{APP_NAME}_development && dropdb #{APP_NAME}_test")
  end

  desc "Migrate the database (options: VERSION=x, VERBOSE=false, SCOPE=blog)."
  task :migrate do
    ActiveRecord::Migrator.migrations_paths << File.dirname(__FILE__) + 'db/migrate'
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate(ActiveRecord::Migrator.migrations_paths, ENV["VERSION"] ? ENV["VERSION"].to_i : nil) do |migration|
      ENV["SCOPE"].blank? || (ENV["SCOPE"] == migration.scope)
    end
  end

  desc "rollback your migration using STEP=number to find a specific point"
  task :rollback do
    step = (ENV['STEP'] || 1).to_i
    ActiveRecord::Migrator.rollback('db/migrate', step)
    Rake::Task['db:version'].invoke if Rake::Task['db:version']
  end

  desc "Seed the database with the seeds.rb file in /db"
  task :seed do
    require APP_ROOT.join('db', 'seeds.rb')
  end

  desc "Return the current schema version number"
  task :version do
    puts "Current version: #{ActiveRecord::Migrator.current_version}"
  end

  namespace :test do
    desc "Migrate test database"
    task :prepare do
      system "rake db:migrate RACK_ENV=test"
    end
  end

end

desc "Start IRB w/ app environment loaded"
task "console" do
  exec "irb -r./config/environment"
end


# The following is only for pushing to heroku. Ignore it otherwise:
begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
rescue LoadError
end

task :default => :spec
