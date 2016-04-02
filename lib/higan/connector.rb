module Higan
  module Connector
    module ClassMethods
      def connect(name, &block)
        Session.new(**ftp_store[name], &block)
      end

      def test_ftp(name)
        config = ftp_store[name]

        Session.new(**config.to_h) { |ftp|
          raise Fail if ftp.closed?
          ftp.chdir(config.base_dir)
        }

        true
      end

      def test_uploading(name, dir_name = '')
        config = ftp_store[name]

        Session.new(**config.to_h) { |ftp|
          raise Fail if ftp.closed?
          ftp.chdir(config.base_dir)
          ftp.mkdir('_' + dir_name + '_' + DateTime.now.strftime('%Y%m%d_%H%M%S'))
        }

        true
      end

      def upload(name)
        target = element_store[name]
        keys = target.element_list.map { |t| target.key(t.id) }
        elements = Uploading.where(key: keys)

        Uploader.new(elements)
      end

      def to(ftp_name, elements)
        config = ftp_store[ftp_name]
        dirs = Set.new
        Session.new(**config.to_h) { |ftp, helper|
          elements.each do |target|
            target_path = config.remote_path(target.path)
            dir = File.dirname(target_path)
            unless dirs.include?(dir)
              helper.mkdir_p(dir)
              dirs.add(dir)
            end
            #ftp.chdir(dir)
            ftp.put(local_file_path(target.path), target_path)
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