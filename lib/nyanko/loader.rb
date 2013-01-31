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

      def const_cache
        @const_cache ||= {}
      end

      def update_checker_cache
        @update_checker_cache ||= {}
      end

      def directory_path
        Config.units_directory_path
      end
    end

    delegate :const_cache, :directory_path, :update_checker_cache, :to => "self.class"

    def initialize(name)
      @name = name
    end

    def load
      if loaded?
        load_from_const_cache
      else
        load_from_file
      end
    end

    def loaded?
      const_cache[@name] != nil
    end

    def load_from_const_cache
      const_cache[@name]
    end

    def load_from_file
      load_file
      const_cache[@name] = constantize
    rescue Exception => exception
      ExceptionHandler.handle(exception)
      const_cache[@name] = false
      nil
    end

    def load_file
      if has_update_checker?
        update_checker.execute_if_updated
      else
        update_checker.execute
      end
    end

    def has_update_checker?
      !!update_checker_cache[path]
    end

    def update_checker
      update_checker_cache[path] ||= ActiveSupport::FileUpdateChecker.new([path]) do
        reload_file
      end
    end

    def reload_file
      Object.send(:remove_const, unit_class_name) rescue nil
      Kernel.load(path)
    end

    def unit_class_name
      @name.to_s.camelize
    end

    def path
      Rails.root.join("#{directory_path}/#@name/#@name.rb").to_s
    end

    def constantize
      unit_class_name.constantize
    rescue NameError
      raise UnitNotFound, "The unit for #{@name.inspect} is not found"
    end
  end
end
