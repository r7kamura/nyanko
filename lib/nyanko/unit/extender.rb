require "nyanko/unit/extender/extension"

module Nyanko
  module Unit
    class Extender
      def initialize(prefix = nil)
        @prefix = prefix
      end

      def expand(mod, &block)
        mod       = mod.to_s.camelize.constantize unless mod.is_a?(Module)
        extension = Extension.new(@prefix, &block)
        mod.class_eval do
          include extension.instance_methods_module
          extend extension.class_methods_module
        end
      end
    end
  end
end
