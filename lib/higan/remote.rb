module Higan
  class Remote
    attr_accessor :host, :user, :password, :mode, :base_dir

    def initialize(**params)
      params.each_pair do |k, v|
        self.send("#{k}=", v)
      end
    end

    def remote_path(path)
      base_dir + path
    end

    def to_h
      {
        host: host,
        user: user,
        password: password,
        mode: mode,
        base_dir: base_dir
      }
    end
  end
end