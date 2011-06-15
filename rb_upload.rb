require 'settings'
require 'local'
require 'remote'
require 'optparse'

class RbUpload
  attr_accessor :settings, :verbose, :comparison_mode, :local

  def initialize
    @settings = Settings.new
    @site = 'development'
  end

  def comparison_mode= mode
    if mode == :lastrun && @settings.lastrun == -1
      @comparison_mode = :filesize
    else
      @comparison_mode = mode
    end
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

  def get_local_path path
    @local.get_relative_path path
  end

  def get_remote_path path
    remote_base = @settings.site_data(@site)['directory']
    File.join(remote_base, path)
  end

  def skip? path
    local_path = get_local_path path
    remote_path = get_remote_path path
    if @comparison_mode == :filesize
      return @remote.files_match?(local_path, remote_path) == :same_size
    elsif @comparison_mode == :lastrun
      return Local.modified_time(local_path) < @settings.lastrun
    else
      return false
    end
  end

  def upload path
    local_path = get_local_path path
    remote_path = get_remote_path path
    if skip? path
      puts "Skipping #{local_path}" if @verbose
      return
    end
    puts "Uploading #{local_path}" if @verbose
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
    @settings.lastrun = Time.now.utc
  end
end

if __FILE__ == $0
  upload = RbUpload.new

  OptionParser.new do |opts|
    opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
      upload.verbose = v
    end
  end.parse!

  #if lastrun doesn't exist use filesize
  upload.comparison_mode = :lastrun
  upload.upload_all
end
