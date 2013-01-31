module Nyanko
  class Railtie < Rails::Railtie
    initializer "nyanko.include" do
      ::ActionView::Base.send(:include, Helper, Invoker, UnitProxyProvider)
      ::ActionController::Base.send(:include, Controller, Invoker, UnitProxyProvider)
      ::ActiveRecord::Base.send(:include, UnitProxyProvider)
      ::ActiveRecord::Relation.send(:include, UnitProxyProvider)
      ::ActiveRecord::Associations::CollectionAssociation.send(:include, UnitProxyProvider)
    end

    initializer "nyanko.eager_load" do
      Loader.eager_load if Config.eager_load
    end
  end
end
