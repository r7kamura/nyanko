module Nyanko
  module ExceptionHandler
    class << self
      def handle(exception)
        logger.debug Message.new(exception).to_s
        raise exception if Config.raise_error
      end

      def logger
        Rails.logger
      end
    end

    class Message
      def initialize(exception)
        @exception = exception
      end

      def to_s
        "#{prefix} #{klass}#{body}\n#{backtrace}"
      end

      def prefix
        "  [Nyanko]"
      end

      def body
        unless @exception.message.empty?
          " - #{@exception}"
        end
      end

      def klass
        @exception.class
      end

      def backtrace
        lines = @exception.backtrace[0...Config.backtrace_limit]
        lines.map {|line| "#{prefix}   #{line}" }.join("\n")
      end
    end
  end
end
