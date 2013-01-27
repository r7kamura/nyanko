module Nyanko
  class Railtie < Rails::Railtie
    initializer "nyanko" do |app|
      ::ActionView::Base.send(:include, Invoker, Helper, UnitProxyProvider)
      ::ActionController::Base.send(:include, Controller)
      ::ActiveRecord::Base.send(:include, UnitProxyProvider)
      ::ActiveRecord::Relation.send(:include, UnitProxyProvider)
      ::ActiveRecord::Associations::CollectionAssociation.send(:include, UnitProxyProvider)
    end
  end
end
