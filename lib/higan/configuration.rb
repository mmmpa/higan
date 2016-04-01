module Higan
  module Configuration
    module ClassMethods
      attr_accessor :ftp_configuration, :target_list, :default,:local_configuration

      def configure(&block)
        instance_eval(&block) if block_given?
      end

      def local(&block)
        self.local_configuration = LocalReceiver.out(&block)
      end

      def ftp(&block)
        self.ftp_configuration = FtpReceiver.out(&block)
      end

      def default(&block)
        self.default = DefaultReceiver.out(&block)
      end

      def add(&block)
        self.target_list ||= []
        target_list.push(Target.new(TargetReceiver.out(&block)))
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    class FtpReceiver
      include ConfigurationReceiver
      receive :host, :user, :password, :mode, :base_dir
    end

    class DefaultReceiver
      include ConfigurationReceiver
      receive :public
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