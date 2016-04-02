require 'net/ftp'

module Higan

  class Session
    attr_accessor :ftp

    def initialize(host:, user:, password:, mode: nil, **rest)
      self.ftp = Net::FTP.new
      ftp.connect(host)
      ftp.login(user, password)
      ftp.binary = mode.to_sym == :binary
      yield(ftp, self) if block_given?
      ftp.close
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