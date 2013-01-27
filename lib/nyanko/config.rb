module Nyanko
  module Config
    class << self
      def units_directory_path
        @units_directory_path ||= "app/units"
      end

      def units_directory_path=(path)
        @units_directory_path = path
      end

      def raise_error
        @raise_error ||= lambda { Rails.env.development? }
        @raise_error.respond_to?(:call) ? @raise_error.call : @raise_error
      end

      def raise_error=(raise_error)
        @raise_error = raise_error
      end

      def backtrace_limit
        @backtrace_limit ||= 10
      end

      def backtrace_limit=(limit)
        @backtrace_limit = limit
      end
    end
  end
end
