module Higan
  class Target
    attr_accessor :klass, :scope, :path, :renderer, :template, :value

    def initialize(**params)
      params.each_pair do |k, v|
        self.send("#{k}=", v)
      end
    end

    def record_list
      klass.send(scope)
    end
  end
end