require "yaml"

class RbUpload
  attr_accessor :settings

  def initialize
    File.open('upload_settings.yml') do |yf|
      @settings = YAML::load(yf)
    end
  end
end
