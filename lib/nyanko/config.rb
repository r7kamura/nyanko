module Nyanko
  module Config
    class << self
      attr_accessor(
        :backtrace_limit,
        :cache_units,
        :raise_error,
        :units_directory_path
      )

      def reset
        self.backtrace_limit      = 10
        self.cache_units          = !Rails.env.development?
        self.raise_error          = Rails.env.development?
        self.units_directory_path = "app/units"
      end
    end

    reset
  end
end
