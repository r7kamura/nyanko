require "pathname"

module Nyanko
  class Loader
    class << self
      def load(unit_name)
        new(unit_name).load
      end
    end

    def initialize(name)
      @name = name
    end

    def load
      require_unit_files
      constantize
    end

    def require_unit_files
      paths.each {|path| require path }
    end

    def paths
      Pathname.glob("#{directory_path}/#@name/#@name.rb").sort
    end

    def directory_path
      Config.units_directory_path
    end

    def constantize
      @name.to_s.camelize.constantize
    rescue NameError
    end
  end
end
