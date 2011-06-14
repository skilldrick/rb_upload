require 'net/ftp'

class Remote
  attr_accessor :connected

  def connect(credentials)
    ftp = Net::FTP.new(credentials.machine)
    ftp.passive = true
    ftp.login(credentials.login, credentials.password)
    ftp.list #force it to do something
  end
end
