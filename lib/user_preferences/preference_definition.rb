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
      value = to_bool(value) if binary?
      permitted_values.index(value)
    end

    private

    def to_bool(value)
      return true if value == 1
      return true if value == true || value =~ (/^(true|t|yes|y|1)$/i)

      return false if value == 0
      return false if value == false || value.blank? || value =~ (/^(false|f|no|n|0)$/i)
      raise ArgumentError.new("invalid value for Boolean: \"#{value}\"")
    end
  end
end
