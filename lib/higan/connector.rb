module Higan
  module Connector
    module ClassMethods
      def remote_file_path(path)
        ftp_configuration[:base_dir] + path
      end

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
        dirs = Set.new
        Session.new(**ftp_configuration) { |ftp, helper|
          Uploading.all.each do |target|
            target_path = remote_file_path(target.path)
            dir = File.dirname(target_path)
            unless dirs.include?(dir)
              helper.mkdir_p(dir)
              dirs.add(dir)
            end
            ftp.chdir(dir)
            ftp.put(local_file_path(target.path), remote_file_path(target.path))
          end
        }
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end

    class Fail < StandardError

    end
  end
end