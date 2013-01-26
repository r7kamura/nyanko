module Nyanko
  class Function
    attr_reader :block

    def initialize(&block)
      @block = block
    end

    def invoke(context, options = {})
      context.instance_eval(&block)
    end
  end
end
