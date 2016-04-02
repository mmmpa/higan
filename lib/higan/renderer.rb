module Higan
  module Renderer
    module ClassMethods
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

      def write_temp(name)
        render(name).flatten.each do |target|
          target_path = local_file_path(target.path)
          FileUtils.mkdir_p(File.dirname(target_path))
          File.write(target_path, target.body)
        end
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

      def render(name)
        target = element_store[name]
        renderer = detect_renderer(target)

        target.element_list.map do |element|
          key = target.key(element.id)
          uploading = Uploading.find_by(key: key) || Uploading.new
          uploading.update!(
            key: key,
            path: target.path.call(element),
            body: renderer.call(element),
            source_updated_at: element.updated_at
          )
          uploading
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