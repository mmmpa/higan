module Higan
  class Rendered
    attr_accessor :path, :body, :updated_at

    def initialize(**params)
      params.each_pair do |k, v|
        self.send("#{k}=", v)
      end
    end
  end
end