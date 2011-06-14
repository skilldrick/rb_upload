require 'settings'
require 'local'

class RbUpload
  attr_accessor :settings

  def initialize
    @settings = Settings.new
  end

  def get_local_files
    @local = Local.new(
      @settings.ignored_prefixes, @settings.ignored_suffixes, @settings.local_directory
    )
    @local.get_files
  end

end

if __FILE__ == $0
  upload = RbUpload.new
end
