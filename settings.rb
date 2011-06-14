require 'yaml'
require 'net/netrc'


class Settings
  def initialize
    load_yaml
  end

  def site_data site_name
    @data[site_name]
  end

  def site_credentials site_name
    host = site_data(site_name)['host']
    get_login_from_host host
  end

  def load_yaml
    File.open('upload_settings.yml') do |file|
      @data = YAML::load(file)
    end
  end

  def get_login_from_host(host)
    @netrc = Net::Netrc.locate(host) or raise ".netrc or host not found"
    @netrc.login
  end
end

if __FILE__ == $0
  upload = RbUpload.new
end
