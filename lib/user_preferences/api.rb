module UserPreferences
  class API
    def initialize(category, scope)
      @category = category
      @scope = scope.where(category: category)
    end

    def all
      serialized_preferences
    end

    def get(name)
      serialized_preferences[name]
    end

    def set(hash)
      hash_setter do
        hash.each do |name, value|
          find_or_init_preference(name).update_value!(value)
        end
        reload
      end
    end

    def reload
      @_saved_preferences = nil
      all
    end

    private

    def serialized_preferences
      default_preferences.merge Hash[saved_preferences.map { |p| [p.name.to_sym, p.value] }]
    end

    def default_preferences
      @_category_defaults ||= UserPreferences.defaults(@category)
    end

    def saved_preferences
      @_saved_preferences ||= @scope.select([:id, :category, :name, :value, :user_id])
    end

    def find_or_init_preference(name)
      @scope.find_or_initialize_by(name: name, category: @category)
    end

    def hash_setter(&block)
      ActiveRecord::Base.transaction do
        result = true
        begin
          yield
        rescue ActiveRecord::RecordInvalid
          result = false
        end
        result
      end
    end
  end
end
