require "nyanko/invoker/options"
require "nyanko/invoker/function_finder"

module Nyanko
  module Invoker
    def invoke(*args)
      options  = Options.new(*args)
      function = FunctionFinder.find(self, options)
      function.invoke(self, options.invoke_options) if function
    end
  end
end
