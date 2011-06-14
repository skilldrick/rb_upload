require 'settings'
require 'local_files'

class RbUpload
  attr_accessor :settings

  def initialize
    @settings = Settings.new
  end

  def get_local_files
    @local_files = LocalFiles.new ['ignored_dir'], ['.swp'], 'test_files'
    @local_files.get_files
  end

end

if __FILE__ == $0
  upload = RbUpload.new
end
