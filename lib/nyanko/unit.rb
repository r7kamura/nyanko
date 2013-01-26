require "nyanko/unit/scope_finder"

module Nyanko
  module Unit
    extend ActiveSupport::Concern

    included do
      active_if { true }
    end

    module ClassMethods
      attr_accessor :current_scope

      delegate :active?, :to => :@active_if

      def scope(identifier)
        self.current_scope = ScopeFinder.find(identifier)
        scopes[current_scope] ||= {}
        yield
      ensure
        self.current_scope = nil
      end

      def function(label, &block)
        functions[label] = Function.new(self, label, &block)
      end

      def shared(label, &block)
        shared_methods[label] = block
      end

      def helpers(&block)
        Helper.define(name, &block)
      end

      def active_if(*conditions, &block)
        @active_if = ActiveIf.new(*conditions, &block)
      end

      def any(*labels)
        ActiveIf::Any.new(*labels)
      end

      def find_function(identifier, label)
        klass      = ScopeFinder.find(identifier)
        candidates = scopes.keys
        target     = klass.ancestors.find {|klass| scopes[klass] }
        scope      = scopes[target]
        scope[label] if scope
      end

      def functions
        scopes[current_scope]
      end

      def scopes
        @scopes ||= {}
      end

      def shared_methods
        @shared_methods ||= {}
      end
    end
  end
end
