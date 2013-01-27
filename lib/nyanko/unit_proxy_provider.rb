module Nyanko
  module UnitProxyProvider
    NoUnitError = Class.new(StandardError)

    extend ActiveSupport::Concern

    included do
      extend UnitProxyProvider
      include Helper
    end

    def unit(name = nil)
      name ||= Function.current_unit.try(:to_key)
      if name && unit = Loader.load(name)
        UnitProxy.new(unit, self)
      else
        raise NoUnitError
      end
    end
  end
end
