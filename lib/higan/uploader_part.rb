module Higan
  class UploaderPart
    attr_accessor :local_file, :remote_file, :path, :uploading

    def initialize(**params)
      params.each_pair do |k, v|
        self.send("#{k}=", v)
      end
    end

    def ok?
      !!remote_file
    end

    def update!(**params)
      uploading.update!(**params) if !!uploading
    end

    def configure!(config)
      self.remote_file = config.remote_path(path)
    end
  end
end
