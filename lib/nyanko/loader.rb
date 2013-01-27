require "pathname"

module Nyanko
  class Loader
    UnitNotFound = Class.new(StandardError)

    class << self
      def load(unit_name)
        new(unit_name).load
      end

      def cache
        @cache ||= {}
      end
    end

    def initialize(name)
      @name = name
    end

    def load
      loaded? ? load_from_cache : load_from_file
    end

    def loaded?
      cache[@name] != nil
    end

    def load_from_cache
      cache[@name]
    end

    def load_from_file
      require_unit_files
      cache[@name] = constantize
    rescue Exception => exception
      ExceptionHandler.handle(exception)
      cache[@name] = false
      nil
    end

    def require_unit_files
      paths.each {|path| require Rails.root.join(path) }
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
      raise UnitNotFound, "The unit for #{@name.inspect} is not found"
    end

    def cache
      self.class.cache
    end
  end
end
