module Higan
  class Uploader
    attr_accessor :elements

    def initialize(elements)
      self.elements = elements
    end

    def to(name)
      Higan.to(name, elements)
    end
  end
end