module Higan
  module Configurator
    module ClassMethods
      attr_accessor :_basic, :_ftp_store, :_local_store, :_element_store

      def init
        self._ftp_store = {}
        self._local_store = {}
        self._element_store = {}
      end

      def add_ftp(name, &block)
        _ftp_store[name] = block
      end

      def base(&block)
        self._basic = block
      end

      def add_element(name, &block)
        _element_store[name] = block
      end

      def configure
        basic = _basic
        ftp_store = _ftp_store
        local_store = _local_store
        element_store = _element_store

        Higan.configure do
          base &basic

          ftp_store.each_pair do |k,v|
            add_ftp(k, &v)
          end

          local_store.each_pair do |k,v|
            add_local(k, &v)
          end

          element_store.each_pair do |k,v|
            add_element(k, &v)
          end
        end
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
      klass.init
    end
  end

  module Configuration
    module ClassMethods
      attr_accessor :configurator, :basic, :ftp_store, :local_store, :element_store, :configured

      def configure!
        return if configured
        self.configured = true unless development?

        eval('::' + configurator).configure
      end

      def configuration(class_name)
        self.configurator = class_name
      end

      def configure(&block)
        self.ftp_store = {}
        self.local_store = {}
        self.element_store = {}
        instance_eval(&block) if block_given?
      end

      def add_ftp(name, &block)
          ftp_store[name] = Remote.new(FtpReceiver.out(&block))
      end

      def base(&block)
          self.basic = BaseReceiver.out(&block)
      end

      def add_element(name, &block)
          element_store[name] = Target.new(TargetReceiver.out(&block))
      end

      def inspect
        {
          basic: basic,
          ftp: ftp_store,
          local: local_store,
          element: element_store
        }
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    class FtpReceiver
      include ConfigurationReceiver
      receive :host, :user, :password, :mode, :base_dir
    end

    class BaseReceiver
      include ConfigurationReceiver
      receive :public, :temp_dir
    end

    class TargetReceiver
      include ConfigurationReceiver
      receive :klass, :scope, :path, :renderer, :template, :value
    end

    class LocalReceiver
      include ConfigurationReceiver
      receive :temp_dir
    end
  end
end