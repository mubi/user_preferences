module UserPreferences
  class Defaults
    def initialize(definitions)
      @definitions = definitions
    end

    def get(category = nil)
      if category
        category_defaults(category)
      else
        @definitions.inject({}) { |h, (k,v)| h[k.to_sym] = category_defaults(k); h }
      end
    end

    private

    def category_defaults(category)
      @definitions[category].inject({}) do |h, (k,v)|
        h[k.to_sym] = v.is_a?(Hash) ? v['default'] : v; h
      end
    end
  end
end