require "nyanko/invoker/options"
require "nyanko/invoker/function_finder"

module Nyanko
  module Invoker
    def invoke(*args, &block)
      options = Options.new(*args)
      __with_default_stack(block) do
        __with_unit_locals_stack(options.locals) do
          if function = FunctionFinder.find(self, options)
            function.invoke(self, options.invoke_options)
          else
            run_default
          end
        end
      end
    end

    def units
      @units ||= []
    end

    def view?
      is_a?(ActionView::Base)
    end

    def run_default
      __invoke_default_block if __has_default_block?
    end

    private

    def method_missing(method_name, *args, &block)
      if shared_method = __find_shared_method(method_name)
        instance_exec(*args, &shared_method)
      elsif args.empty? && local = __find_unit_local(method_name)
        local
      else
        super
      end
    end

    def __find_unit_local(method_name)
      __current_unit_locals[method_name]
    end

    def __current_unit_locals
      __unit_locals_stack.last || {}
    end

    def __unit_locals_stack
      @__unit_locals_stack ||= []
    end

    def __find_shared_method(method_name)
      __current_shared_methods[method_name]
    end

    def __current_shared_methods
      __current_unit.try(:shared_methods) || {}
    end

    def __current_unit
      units.last
    end

    def __defaults_stack
      @__defaults_stack ||= []
    end

    def __default_block
      __defaults_stack.last
    end

    def __has_default_block?
      !!__default_block
    end

    def __invoke_default_block
      if view?
        capture(&__default_block)
      else
        instance_exec(&__default_block)
      end
    end

    def __with_default_stack(default)
      __defaults_stack << default
      yield
    ensure
      __defaults_stack.pop
    end

    def __with_unit_locals_stack(locals)
      __unit_locals_stack << locals
      yield
    ensure
      __unit_locals_stack.pop
    end
  end
end
