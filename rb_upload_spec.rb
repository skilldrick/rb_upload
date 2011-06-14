require 'rb_upload'
require 'local_files'

describe RbUpload do
  before(:each) do
    @upload = RbUpload.new
  end

  it "should be able to get local files" do
    #would this be better stubbed?
    @upload.get_local_files.should have_at_least(2).items
  end

end
