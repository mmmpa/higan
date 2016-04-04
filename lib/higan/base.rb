module Higan
  module Base
    module ClassMethods
      class Fail < StandardError

      end

      def ftp_data
        ftp_store.each_pair.map do |k, v|
          {name: k}.merge!(v.to_h)
        end
      end

      def local_data
        local_store.each_pair.map do |k, v|
          {name: k}.merge!(v.to_h)
        end
      end

      def element_data
        element_store.each_pair.map do |k, v|
          {name: k}.merge!(v.to_h)
        end
      end

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
        write_temp(name)

        target = element_store[name]
        keys = target.element_list.map { |t| target.key(t.id) }
        elements = Uploading.where { (key.in keys) & ((uploaded_at == nil) | (source_updated_at > uploaded_at)) }

        pp elements

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

            target.update!(uploaded_at: DateTime.now)
          end
        }
      end

      def element_klass(name)
        element_store[name].klass
      end

      def element_list(name)
        element_store[name].element_list
      end

      def local_file_path(path)
        basic[:temp_dir] + path
      end

      def render_test(name)
        render(name)
      end

      def template_renderer(file)
        ->(record) {
          view = ActionView::Base.new(ActionController::Base.view_paths, {})
          view.assign({record: record})
          view.render(file: file)
        }
      end

      def detect_renderer(target)
        case
          when target.renderer
            target.renderer
          when target.template
            template_renderer(target.template)
          else
            default_renderer(target.klass)
        end
      end

      def preview(name, id)
        target = element_store[name]
        renderer = detect_renderer(target)
        element = target.element_list.find(id)
        renderer.call(element)
      end

      #
      # render結果をDBに保持する
      #
      def render(name)
        target = element_store[name]
        renderer = detect_renderer(target)

        target.element_list.map do |element|
          key = target.key(element.id)
          uploading = Uploading.find_by(key: key) || Uploading.new

          if uploading.source_updated_at && uploading.source_updated_at > element.updated_at
            next uploading
          end

          uploading.update!(
            key: key,
            path: target.path.call(element),
            body: renderer.call(element),
            written: false,
            source_updated_at: DateTime.now
          )
          uploading
        end
      end

      #
      # render結果をファイルに書き出す
      #
      def write_temp(name)
        render(name).flatten.each do |target|
          if target.written
            next
          end
          target_path = local_file_path(target.path)
          FileUtils.mkdir_p(File.dirname(target_path))
          File.write(target_path, target.body)
          target.update!(written: true)
        end
      end

      def default_renderer(klass)
        column_names = klass.column_names
        ->(record) {
          column_names.map { |name|
            value = record.send(name)
            "#{name} = #{value}"
          }.join('<br>').html_safe
        }
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end