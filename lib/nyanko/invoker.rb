require "nyanko/invoker/options"
require "nyanko/invoker/function_finder"

module Nyanko
  module Invoker
    def invoke(*args, &block)
      options = Options.new(*args)
      unit_locals_stack << options.locals
      function = FunctionFinder.find(self, options)
      result   = function.invoke(self, options.invoke_options)
      result   = surround_with_html_tag(result, function, options) if view?
      result
    rescue Exception
      p $!
      case
      when !block
        nil
      when view?
        capture(&block)
      else
        instance_exec(&block)
      end
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

    def surround_with_html_tag(str, function, options)
      classes = %W[
        unit
        unit__#{function.unit.name.underscore}
        unit__#{function.unit.name.underscore}__#{function.label}
      ]
      case options.type
      when :plain
        str
      when :inline
        content_tag(:span, str, :class => classes)
      else
        content_tag(:div, str, :class => classes)
      end
    end

    def view?
      is_a?(ActionView::Base)
    end
  end
end
