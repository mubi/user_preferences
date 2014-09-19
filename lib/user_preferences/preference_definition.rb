module UserPreferences
  class PreferenceDefinition
    attr_reader :name, :category

    def initialize(definition, category, name)
      @definition = definition
      @category = category
      @name = name
    end

    def permitted_values
      if binary?
        result = [false, true]
      else
        @definition[:values]
      end
    end

    def binary?
      !@definition.is_a?(Hash)
    end

    def default
      binary? ? @definition : @definition[:default]
    end

    def lookup(index)
      permitted_values[index] if index
    end

    def to_db(value)
      permitted_values.index(value)
    end
  end
end