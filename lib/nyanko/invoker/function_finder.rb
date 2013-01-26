module Nyanko
  module Invoker
    class FunctionFinder
      def self.find(*args)
        new(*args).find
      end

      def initialize(context, options)
        @context = context
        @options = options
      end

      def find
        @options[:functions].each do |unit_name, label|
          unit       = find_unit(unit_name)
          identifier = @options[:as] || @context.class
          next unless unit.active?(@context, @options[:active_if_options])
          function = unit.find_function(identifier, label)
          break function if function
        end
      end

      def find_with_dependencies
        find_without_dependencies unless has_inactive_dependent_unit?
      end
      alias_method_chain :find, :dependencies

      def find_unit(name)
        Loader.load(name)
      end

      def has_inactive_dependent_unit?
        dependent_units.any? {|unit| !unit.active?(@context, @options[:active_if_options]) }
      end

      def dependent_units
        dependent_unit_names.map {|name| find_unit(name) }
      end

      def dependent_unit_names
        Array.wrap(@options[:dependencies])
      end
    end
  end
end
