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
        context.instance_eval(&block)
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
  end
end
