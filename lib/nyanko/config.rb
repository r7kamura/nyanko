module Nyanko
  module Config
    class << self
      attr_accessor(
        :backtrace_limit,
        :cache_units,
        :clear_units_cache,
        :compatible_css_class,
        :enable_logger,
        :proxy_method_name,
        :raise_error,
        :units_directory_path
      )

      def reset
        self.backtrace_limit      = 10
        self.clear_units_cache    = Rails.env.development? || Rails.env.test?
        self.enable_logger        = true
        self.proxy_method_name    = :unit
        self.raise_error          = Rails.env.development?
        self.units_directory_path = "app/units"
      end
    end

    reset
  end
end
