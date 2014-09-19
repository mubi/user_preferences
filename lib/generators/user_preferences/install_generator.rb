module UserPreferences
  module Generators
    class InstallGenerator < Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)

      def create_initializer_file
        template 'user_preferences.yml', "config/user_preferences.yml"
      end

      def copy_migrations
        migration_template 'migration.rb', "db/migrate/create_preferences.rb"
      end

      # TODO get rid of this
      def self.next_migration_number(dir)
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      end
    end
  end
end