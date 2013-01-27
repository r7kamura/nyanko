module Nyanko
  class Function
    attr_reader :block, :unit, :label

    class << self
      def units
        @units ||= []
      end

      def current_unit
        units.last
      end
    end

    def initialize(unit, label, &block)
      @unit  = unit
      @label = label
      @block = block
    end

    def invoke(context, options = {})
      with_unit_stack(context) do
        with_unit_view_path(context) do
          context.instance_eval(&block)
        end
      end
    end

    private

    def with_unit_stack(context)
      context.units << @unit
      self.class.units << @unit
      yield
    ensure
      self.class.units.pop
      context.units.pop
    end

    def with_unit_view_path(context)
      if context.view?
        origin = context.view_paths
        context.view_paths.unshift unit.view_path
      end
      yield
    ensure
      context.view_paths = origin if context.view?
    end
  end
end
