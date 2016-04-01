module Higan
  module Renderer
    module ClassMethods

      def render_test
        render
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

      def render
        target_list.map do |target|
          renderer = detect_renderer(target)
          klass_name = target.klass.to_s
          target.record_list.map do |record|
            key = [klass_name, record.id].join('::')
            uploading = Uploading.find_by(key: key) || Uploading.new
            uploading.update!(
              key: [klass_name, record.id].join('::'),
              path: target.path.call(record),
              body: renderer.call(record),
              source_updated_at: record.updated_at
            )
            uploading
          end
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