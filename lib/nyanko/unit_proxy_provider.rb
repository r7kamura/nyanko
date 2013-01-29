module Nyanko
  module UnitProxyProvider
    extend ActiveSupport::Concern

    included do
      extend UnitProxyProvider
      include Helper
    end

    def method_missing(method_name, *args, &block)
      if method_name == Config.proxy_method_name.to_sym
        UnitProxyProvider.class_eval do
          define_method(method_name) do |*_args|
            name = _args.first || Function.current_unit.try(:unit_name)
            if name && unit = Loader.load(name)
              UnitProxy.new(unit, self)
            end
          end
        end
        send(method_name, args.first)
      else
        super
      end
    end
  end
end
