module Nyanko
  module Config
    class << self
      attr_accessor(
        :backtrace_limit,
        :cache_units,
        :compatible_css_class,
        :enable_logger,
        :raise_error,
        :units_directory_path
      )

      def reset
        self.backtrace_limit      = 10
        self.cache_units          = !Rails.env.development?
        self.enable_logger        = true
        self.raise_error          = Rails.env.development?
        self.units_directory_path = "app/units"
      end
    end

    reset
  end
end
