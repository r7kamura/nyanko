module Nyanko
  module Logger

    class << self
      ::Logger::Severity.constants.each do |level|
        method_name = level.downcase
        define_method(method_name) do |message|
          logger.send(method_name, decorate(message)) if Config.enable_logger
        end
      end

      def decorate(message)
        Message.new(message).to_s
      end

      def logger
        Rails.logger
      end
    end

    class Message
      PREFIX = "  [Nyanko]"

      def initialize(object)
        @object = object
      end

      def to_s
        prefix(content)
      end

      def prefix(str)
        str.split("\n").map {|line| "#{PREFIX} #{line}" }.join("\n")
      end

      def content
        if @object.is_a?(Exception)
          "#{klass}#{body}\n#{backtrace}"
        else
          @object.to_s
        end
      end

      def body
        unless @object.message.empty?
          " - #@object"
        end
      end

      def klass
        @object.class
      end

      def backtrace
        lines = @object.backtrace[0...Config.backtrace_limit]
        lines.map {|line| "  #{line}" }.join("\n")
      end
    end
  end
end
