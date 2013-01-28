module Nyanko
  module UnitProxyProvider
    extend ActiveSupport::Concern

    included do
      extend UnitProxyProvider
      include Helper
    end

    def unit(name = nil)
      name ||= Function.current_unit.try(:to_key)
      if name && unit = Loader.load(name)
        UnitProxy.new(unit, self)
      end
    end
    alias_method :ext, :unit
  end
end
