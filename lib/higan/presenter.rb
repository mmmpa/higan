module Higan
  module Presenter
    module ClassMethods
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
    end

    def self.included(klass)
      klass.extend ClassMethods
    end
  end
end