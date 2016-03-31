module Higan
  module Connector
    module ClassMethods
      def test_connecting
        Session.new(**ftp_configuration) { |ftp|
          raise Fail if ftp.closed?
          ftp.chdir(ftp_configuration[:base_dir])
        }
      end

      def test_uploading(dir_name = '')
        Session.new(**ftp_configuration) { |ftp|
          raise Fail if ftp.closed?
          ftp.chdir(ftp_configuration[:base_dir])
          ftp.mkdir('_' + dir_name + '_' + DateTime.now.strftime('%Y%m%d_%H%M%S'))
        }
      end

      def upload

      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    class Fail < StandardError

    end
  end
end