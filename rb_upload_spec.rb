require 'rb_upload'
require 'local_files'

describe RbUpload do
  before(:each) do
    @upload = RbUpload.new
  end

  it "should pass correct params to LocalFiles" do
    return_val = ['a', 'b', 'c']
    mock_local_files = mock('local_files')
    mock_local_files.stub!(:get_files).and_return(return_val)
    mock_local_files.should_receive(:get_files)
    LocalFiles.stub!(:new).and_return(mock_local_files)
    LocalFiles.should_receive(:new).with(
      instance_of(Array),
      instance_of(Array),
      instance_of(String)
    )
    @upload.get_local_files.should == return_val
  end

end
