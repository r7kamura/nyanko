module Nyanko
  module ExceptionHandler
    class << self
      def handle(exception)
        Logger.debug(exception)
        raise exception if Config.raise_error
      end
    end
  end
end
