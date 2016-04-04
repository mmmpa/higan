require 'net/ftp'

module Higan
  class Session
    attr_accessor :ftp, :dirs

    def initialize(host:, user:, password:, mode: nil, **rest)
      self.dirs = Set.new

      self.ftp = Net::FTP.new
      ftp.connect(host)
      ftp.login(user, password)
      ftp.binary = mode.to_sym == :binary
      yield(self) if block_given?
      ftp.close
    end

    def put(local, remote)
      dir = File.dirname(remote)

      unless dirs.include?(dir)
        mkdir_p(dir)
        dirs.add(dir)
      end

      ftp.put(local, remote)
    end

    def mkdir_p(path)
      dirs = path
      ftp.chdir('/')
      dirs.split('/').each do |dir_name|
        next if dir_name.blank?
        file_name_list = ftp.ls.map { |line| line.match(/([^\s]+$)/)[1] }
        unless file_name_list.include? dir_name
          ftp.mkdir(dir_name)
        end
        ftp.chdir(dir_name)
      end
      ftp.chdir('/')
    end
  end
end