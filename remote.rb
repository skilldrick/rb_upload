require 'net/ftp'

class Remote
  attr_accessor :connected

  def connect(credentials)
    @ftp = Net::FTP.new(credentials.machine)
    @ftp.passive = true
    @ftp.login(credentials.login, credentials.password)
  end

  def list
    @ftp.list
  end

  def upload(from_path, to_path)
  end

end
