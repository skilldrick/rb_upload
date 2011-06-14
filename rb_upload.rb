require 'settings'

class RbUpload
  attr_accessor :settings

  def initialize
    @settings = Settings.new
  end

end

if __FILE__ == $0
  upload = RbUpload.new
end
