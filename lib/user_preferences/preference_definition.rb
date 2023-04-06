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

    def acts_as_binary?
      !binary? && @definition[:acts_as_binary] == true
    end

    def lookup(index)
      permitted_values[index] if index
    end

    def to_db(value)
      value = if binary?
                to_bool_force(value)
              elsif acts_as_binary?
                to_bool_maybe(value)
              else
                value
             end

      permitted_values.index(value)
    end

    private

    def to_bool(value)
      return true if value == 1
      return true if value == true || value.to_s =~ (/^(true|t|yes|y|1)$/i)

      return false if value == 0
      return false if value == false || value.blank? || value.to_s =~ (/^(false|f|no|n|0)$/i)
    end

    def to_bool_force(value)
      value = to_bool(value)
      raise ArgumentError.new("invalid value for Boolean: \"#{value}\"") if value.nil?

      value
    end

    def to_bool_maybe(value)
      boolean = to_bool(value)

      boolean.nil? ? value : boolean
    end
  end
end
