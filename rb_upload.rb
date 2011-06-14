require 'yaml'
require 'net/netrc'


class RbUpload
  attr_accessor :settings

  def initialize
    File.open('upload_settings.yml') do |yf|
      @settings = YAML::load(yf)
    end
  end

  def getLogin(host)
    rc = Net::Netrc.locate(host) or raise ".netrc not found"
    rc.login
  end
end

if __FILE__ == $0
  upload = RbUpload.new
end
