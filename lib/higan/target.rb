module Higan
  class Target
    attr_accessor :klass, :scope, :path, :renderer, :template, :value

    def initialize(**params)
      params.each_pair do |k, v|
        self.send("#{k}=", v)
      end
    end

    def element_list
      klass.send(scope)
    end

    def key(id)
      [klass, id].join('::')
    end

    def to_h
      {
        klass: klass,
        scope: scope
      }
    end
  end
end