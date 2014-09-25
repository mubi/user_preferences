require 'yaml'
require 'active_support'
require 'active_support/core_ext/hash'

module UserPreferences
  extend ActiveSupport::Autoload

  autoload :API, 'user_preferences/api'
  autoload :Defaults
  autoload :HasPreferences
  autoload :Preference
  autoload :PreferenceDefinition
  autoload :VERSION

  class << self
    def [](category, name)
      unless (pref = definitions[category].try(:[], name)).nil?
        PreferenceDefinition.new(pref, category, name)
      end
    end

    def defaults(category = nil)
      @_defaults ||= Defaults.new(definitions)
      @_defaults.get(category)
    end

    def yml_path
      Rails.root.join('config', 'user_preferences.yml') if defined?(Rails)
    end

    def definitions
      @_definitions ||= YAML.load_file(yml_path).with_indifferent_access
    end
  end
end

require 'user_preferences/railtie' if defined?(Rails)