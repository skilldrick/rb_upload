require 'yaml'
require 'net/netrc'
require 'time'


class Settings
  def initialize
    load_yaml
  end

  def lastrun
    Lastrun.new
  end

  def site_data site_name
    @data[site_name]
  end

  def load_yaml
    File.open('upload_settings.yml') do |file|
      @data = YAML::load(file)
    end
  end

  def get_credentials_from_site site_name
    get_credentials_from_host site_data(site_name)['host']
  end

  def get_credentials_from_host(host)
    @netrc = Net::Netrc.locate(host) or raise ".netrc or host not found"
    @netrc
  end

  def method_missing msg
    @data[msg.to_s]
  end
end

class Lastrun
  @@lastrun_prefix = '.lastrun'

  def []= key, time
    filename = "#{@@lastrun_prefix}_#{key}"
    File.open(filename, 'w') do |file|
      file << time << "\n"
    end
  end

  def [] key
    filename = "#{@@lastrun_prefix}_#{key}"
    File.open(filename) do |file|
      Time.parse file.read.chomp
    end
  rescue Errno::ENOENT
    -1
  end
end

