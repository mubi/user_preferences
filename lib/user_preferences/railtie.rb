module UserPreferences
  class Railtie < ::Rails::Railtie
    initializer 'user_preferences.has_preferences' do
      ActiveSupport.on_load(:active_record) do
        extend UserPreferences::HasPreferences::ActiveRecordExtension
      end
    end
  end
end