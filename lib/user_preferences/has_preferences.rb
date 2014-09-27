module UserPreferences
  module HasPreferences
    extend ActiveSupport::Concern

    module ActiveRecordExtension
      def has_preferences
        include HasPreferences
      end
    end

    included do
      has_many :saved_preferences, class_name: 'UserPreferences::Preference', dependent: :destroy

      def preferences(category)
        @_preference_apis ||= {}
        @_preference_apis[category] ||= UserPreferences::API.new(category, saved_preferences)
      end

      def self.with_preference(category, name, value)
        definition = UserPreferences[category, name]
        db_value = definition.to_db(value)
        scope = select('users.*, p.id as preference_id')
        join = %Q{
          %s join #{UserPreferences::Preference.table_name} p
          on p.category = '#{category}' and p.name = '#{name}'
          and p.user_id = #{self.table_name}.id
        }
        if value != definition.default
          scope.joins(join % 'inner').where("p.value = #{db_value}")
        else
          scope.joins(join % 'left').where("p.value = #{db_value} or p.id is null")
        end
      end
    end
  end
end