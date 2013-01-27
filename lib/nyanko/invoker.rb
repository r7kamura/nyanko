require "nyanko/invoker/options"
require "nyanko/invoker/function_finder"

module Nyanko
  module Invoker
    def invoke(*args)
      options  = Options.new(*args)
      unit_locals_stack << options.locals
      function = FunctionFinder.find(self, options)
      function.invoke(self, options.invoke_options)
    rescue Exception
      yield if block_given?
    ensure
      unit_locals_stack.pop
    end

    def units
      @units ||= []
    end

    private

    # Search shared method or locals variable
    def method_missing(method_name, *args, &block)
      if (methods = units.last.try(:shared_methods)) && block = methods[method_name]
        self.instance_exec(*args, &block)
      elsif args.empty? && value = (unit_locals_stack.last || {})[method_name]
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
