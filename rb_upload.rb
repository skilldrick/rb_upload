#!/usr/bin/env ruby1.8
require 'rubygems'
require 'pathname'

#requires a relative path when script is executed via a symlink
def relative_require path
  realpath = Pathname.new(__FILE__).realpath #follow symlink
  require File.expand_path("../#{path}", realpath)
end

relative_require 'settings'
relative_require 'local'
relative_require 'remote'
require 'optparse'

class RbUpload
  attr_accessor :settings, :site, :verbose, :comparison_mode, :local

  def initialize
    @settings = Settings.new
    @site = 'development'
  end

  def comparison_mode= mode
    if mode == :lastrun && @settings.lastrun == -1
      puts ".lastrun not found - reverting to filesize comparison" if @verbose
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
  upload.site = 'development'
  upload.comparison_mode = :lastrun
  upload.verbose = true

  OptionParser.new do |opts|
    opts.on("-q", "--[no-]quiet", "Run quietly") do |q|
      upload.verbose = !v
    end
    opts.on("-s", "--site [SITE]", "Use specific SITE") do |site|
      upload.site = site
    end
    opts.on("--[no-]filesize", "Upload based on filesize") do |fs|
      upload.comparison_mode = :filesize if fs
    end
  end.parse!

  upload.upload_all
end
