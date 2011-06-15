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

  def close
    @ftp && @ftp.close
  end

  def list
    @ftp.list
  end

  def make_dir path
    unless exists? path
      begin
        @ftp.mkdir path
      rescue Net::FTPPermError      #if path can't be made
        make_dir File.dirname(path) #make its parent
        make_dir path               #then make it
      end
    end
  end

  def exists? path
    dirname = File.dirname path
    basename = File.basename path
    listing = @ftp.nlst dirname
    listing.include? basename
  end

  #recursively remove directory, by removing all subdirs and files
  def remove_dir path
    files = []
    dirs = []

    @ftp.list path do |line|
      name = line.split(' ', 9)[8] #should be file or dir name
      is_dir = line.chars.to_a[0] == 'd' #first character is 'd' for dirs
      if is_dir
        dirs << name
      else
        files << name
      end
    end

    files.each do |file|
      remove_file(File.join(path, file))
    end

    dirs.each do |dir|
      unless dir == '.' || dir == '..'
        remove_dir(File.join(path, dir))
      end
    end

    begin
      @ftp.rmdir path
    rescue Net::FTPPermError
    end
  end

  def remove_file path
    @ftp.delete path
  end

  def upload(from_path, to_path)
    if ascii? from_path
      @ftp.puttextfile(from_path, to_path)
    else
      @ftp.putbinaryfile(from_path, to_path)
    end
  rescue Net::FTPPermError
    make_dir File.dirname(to_path)
    upload(from_path, to_path)
  end

  def ascii? file_path
    file_path.end_with?(*@@ascii_extensions)
  end

end
