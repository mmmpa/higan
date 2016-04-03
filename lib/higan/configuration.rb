module Higan
  module Configuration
    module ClassMethods
      attr_accessor :basic, :ftp_store, :local_store, :element_store

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