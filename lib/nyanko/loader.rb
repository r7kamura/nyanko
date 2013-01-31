require "pathname"

module Nyanko
  class Loader
    UnitNotFound = Class.new(StandardError)

    class << self
      def load(unit_name)
        new(unit_name).load
      end

      def eager_load
        Pathname.glob("#{directory_path}/*/*.rb") do |path|
          new(path.basename(".rb").to_s.to_sym).load
        end
      end

      def cache
        @cache ||= {}
      end

      def directory_path
        Config.units_directory_path
      end
    end

    delegate :cache, :directory_path, :to => "self.class"

    def initialize(name)
      @name = name
    end

    def load
      if loaded?
        load_from_cache
      else
        load_from_file
      end
    end

    def loaded?
      cache[@name] != nil
    end

    def load_from_cache
      cache[@name]
    end

    def load_from_file
      add_autoload_path
      cache[@name] = constantize
    rescue Exception => exception
      ExceptionHandler.handle(exception)
      cache[@name] = false
      nil
    end

    def add_autoload_path
      ActiveSupport::Dependencies.autoload_paths << autoload_path
      ActiveSupport::Dependencies.autoload_paths.uniq!
    end

    def autoload_path
      Rails.root.join("#{directory_path}/#@name").to_s
    end

    def constantize
      @name.to_s.camelize.constantize
    rescue NameError
      raise UnitNotFound, "The unit for #{@name.inspect} is not found"
    end
  end
end
