require 'net/ftp'

module Higan
  class Session
    def initialize(host:, user:, password:, mode: nil, **rest)
      ftp = Net::FTP.new
      ftp.connect(host)
      ftp.login(user, password)
      ftp.binary = mode.to_sym == :binary
      yield(ftp) if block_given?
      ftp.close
    end
  end
end