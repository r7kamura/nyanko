module Nyanko
  class Function
    attr_reader :block

    def initialize(unit, label, &block)
      @unit  = unit
      @label = label
      @block = block
    end

    def invoke(context, options = {})
      context.units.push(@unit)
      context.instance_eval(&block)
    ensure
      context.units.pop
    end
  end
end
