require 'yaml'
require 'net/netrc'


class Settings
  @@lastrun_filename = '.lastrun'
  def initialize
    load_yaml
  end

  def lastrun= time
    File.open(@@lastrun_filename, 'w') do |file|
      file << time << "\n"
    end
  end

  def lastrun
    File.open(@@lastrun_filename) do |file|
      file.read.chomp
    end
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

if __FILE__ == $0
  upload = RbUpload.new
end
