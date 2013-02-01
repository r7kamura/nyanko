module Nyanko
  module Invoker
    class FunctionFinder
      FunctionNotFound = Class.new(StandardError)

      def self.find(context, options)
        new(context, options).find or
          raise FunctionNotFound, "The function for #{options[:functions].inspect} is not found"
      end

      def initialize(context, options)
        @context = context
        @options = options
      end

      def find
        @options[:functions].find do |unit_name, label|
          unit       = find_unit(unit_name)
          identifier = @options[:as] || @context.class
          next unless unit.try(:active?, @context, @options[:active_if_options])
          function = unit.find_function(identifier, label)
          break function if function
        end
      end

      def find_unit(name)
        Loader.load(name)
      end
    end
  end
end
