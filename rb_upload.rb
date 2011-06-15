require 'settings'
require 'local'
require 'remote'

class RbUpload
  attr_accessor :settings, :verbose

  def initialize
    @settings = Settings.new
    @site = 'development'
  end

  def init_local
    @local = Local.new(
      @settings.ignored_prefixes, @settings.ignored_suffixes, @settings.local_directory
    )
  end

  def init_remote
    @remote = Remote.new
    credentials = @settings.get_credentials_from_site @site
    @remote.connect credentials
  end

  def close
    @remote && @remote.close
  end

  def get_local_files
    @local.get_files
  end

  def upload path
    local_path = @local.get_relative_path path
    remote_base = @settings.site_data(@site)['directory']
    remote_path = File.join(remote_base, path)
    if @verbose
      puts "Uploading #{local_path}"
    end
    status = @remote.upload(local_path, remote_path, :check_size)
    if @verbose
      if status == :different_size
        puts "Error with #{local_path} - sizes do not match"
      elsif status == :remote_missing
        puts "Error with #{local_path} - #{remote_path} not found"
      end
    end
  end

  def upload_all
    init_local
    init_remote
    files = get_local_files
    files.each do |file|
      upload file
    end
  end
end

if __FILE__ == $0
  upload = RbUpload.new
  upload.verbose = true
  upload.upload_all
end
