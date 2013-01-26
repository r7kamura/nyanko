require "delegate"

module Nyanko
  class UnitProxy
    attr_reader :unit

    def self.generate_prefix(name)
      %{__#{name.underscore.gsub("/", "_")}_}
    end

    def initialize(unit, context)
      @unit    = unit
      @context = context
    end

    def active?(options = {})
      @unit.active?(@context, options)
    end

    private

    def prefix
      self.class.generate_prefix(@unit.name)
    end

    def method_missing(method_name, *args, &block)
      @context.send("#{prefix}#{method_name}", *args, &block)
    end
  end
end
