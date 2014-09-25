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
      @_saved_preferences ||= @scope.select([:id, :category, :name, :value, :user_id]).all
    end

    def find_or_init_preference(name)
      unless preference = saved_preferences.detect { |p| p.name == name }
        preference = @scope.find_by_name(name) || @scope.build(name: name, category: @category)
        saved_preferences << preference
      end
      preference
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