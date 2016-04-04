module Higan
  class FileTarget
    attr_accessor :files, :dir, :base_dir

    def initialize(**params)
      params.each_pair do |k, v|
        begin
          self.send("#{k}=", v)
        rescue
          self.send("_#{k}=", v)
        end
      end
    end

    def to_h
      {
        files: files,
        dir: dir,
        base_dir: base_dir
      }
    end
  end
end