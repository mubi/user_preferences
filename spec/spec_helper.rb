require 'user_preferences'
require 'active_record'
require 'active_record/connection_adapters/sqlite3_adapter'

RSpec.configure do |config|
  $stdout = StringIO.new # silence migrations
  ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
  ActiveRecord::Migrator.migrate(File.expand_path('../migrations', __FILE__))
  $stdout = STDOUT

  # prevent deprecation warnings
  I18n.enforce_available_locales = true

  config.before(:each) { stub_yml }
end

def stub_yml
  fixture = File.expand_path("../fixtures/user_preferences.yml", __FILE__)
  UserPreferences.stub(:yml_path).and_return(fixture)
end

class User < ActiveRecord::Base
  include UserPreferences::HasPreferences
end