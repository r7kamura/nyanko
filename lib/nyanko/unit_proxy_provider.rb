module Nyanko
  module UnitProxyProvider
    NoUnitError = Class.new(StandardError)

    extend ActiveSupport::Concern

    included do
      include Helper
    end

    def unit(name = nil)
      name ||= Function.current_unit.try(:to_key) or raise NoUnitError
      unit = Loader.load(name)
      UnitProxy.new(unit, self)
    end
  end
end
