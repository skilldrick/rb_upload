require 'net/ftp'

class Remote
  attr_accessor :connected
  @@ascii_extensions = ['txt',  'php', 'html']

  def filesize path
    @ftp.size path
  end

  def connect(credentials)
    @ftp = Net::FTP.new(credentials.machine)
    @ftp.passive = true
    @ftp.login(credentials.login, credentials.password)
  end

  def list
    @ftp.list
  end

  def make_dir path
    unless dir_exists? path
      @ftp.mkdir path
    end
  end

  def dir_exists? path
    @ftp.chdir path
    return true
  rescue Net::FTPPermError
    return false
  end

  def upload(from_path, to_path)
    if ascii? from_path
      @ftp.puttextfile(from_path, to_path)
    else
      @ftp.putbinaryfile(from_path, to_path)
    end
  end

  def ascii? file_path
    file_path.end_with?(*@@ascii_extensions)
  end

end
