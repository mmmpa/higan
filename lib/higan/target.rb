module Higan
  class Target

    attr_accessor :klass, :scope, :path, :renderer, :template, :value

    def initialize(**params)
      params.each_pair do |k, v|
        begin
          self.send("#{k}=", v)
        rescue
          self.send("_#{k}=", v)
        end
      end
    end

    def pick(id)
      !!scope ?  element_list.find(id) : klass
    end

    def element_list
      !!scope ? klass.send(scope) : [klass]
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