module Higan
  module ConfigurationReceiver
    module ClassMethods
      def out(&block)
        new(&block).out
      end

      def receive(*names)
        module_eval <<-EOS
          attr_accessor #{names.map { |n| ":_#{n}" }.join(',')}

          def initialize(&block)
            instance_eval(&block)
          end

          def out
           {#{names.map { |n| "#{n}: _#{n}" }.join(',')}}
          end
        EOS

        names.each do |n|
          module_eval <<-EOS
            def #{n}(value)
              self._#{n} = value
            end
          EOS
        end
      end
    end

    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end
