module Nyanko
  module Config
    class << self
      def units_directory_path
        @units_directory_path ||= "app/units"
      end

      def units_directory_path=(path)
        @units_directory_path = path
      end
    end
  end
end
