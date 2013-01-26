require "delegate"

module Nyanko
  class UnitProxy
    attr_reader :unit

    def initialize(unit, context)
      @unit    = unit
      @context = context
    end

    def active?(options = {})
      @unit.active?(@context, options)
    end

    private

    def prefix
      "__#{@unit.to_key}_"
    end

    def method_missing(method_name, *args, &block)
      @context.send("#{prefix}#{method_name}", *args, &block)
    end
  end
end
