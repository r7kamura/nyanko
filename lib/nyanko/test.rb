module Nyanko
  module Test
    def self.activations
      @activations ||= {}
    end

    def enable_unit(unit_name)
      Test.activations[unit_name] = true
    end
    alias_method :enable_ext, :enable_unit

    def disable_unit(unit_name)
      Test.activations[unit_name] = false
    end
    alias_method :disable_ext, :disable_unit
  end

  module Unit
    module ClassMethods
      def active_with_activations?(*args)
        case Test.activations[unit_name]
        when true
          true
        when false
          false
        else
          active_without_activations?(*args)
        end
      end
      alias_method_chain :active?, :activations
    end
  end
end

RSpec.configure do |config|
  config.include Nyanko::Test
  config.after { Nyanko::Test.activations.clear }
end
