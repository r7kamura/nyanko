require "nyanko/unit/scope_finder"

module Nyanko
  module Unit
    extend ActiveSupport::Concern

    module ClassMethods
      attr_accessor :current_scope

      def scope(identifier)
        self.current_scope = ScopeFinder.find(identifier)
        yield
      ensure
        self.current_scope = nil
      end

      def function(label, &block)
        functions[current_scope][label] = block
      end

      def functions
        @functions ||= Hash.new {|hash, key| hash[key] = {} }
      end
    end
  end
end
