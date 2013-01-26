require "nyanko/invoker/options"
require "nyanko/invoker/function_finder"

module Nyanko
  module Invoker
    def invoke(*args)
      options  = Options.new(*args)
      function = FunctionFinder.find(self, options)
      unit_locals_stack.push(options.locals)
      function.invoke(self, options.invoke_options) if function
    ensure
      unit_locals_stack.pop
    end

    private

    def method_missing(method_name, *args, &block)
      if args.empty? && value = (unit_locals_stack.last || {})[method_name]
        value
      else
        super
      end
    end

    def unit_locals_stack
      @unit_locals_stack ||= []
    end
  end
end
