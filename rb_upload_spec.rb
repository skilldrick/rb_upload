require 'rb_upload'
require 'local'

describe RbUpload do
  before(:each) do
    @upload = RbUpload.new
  end

  it "should pass correct params to LocalFiles" do
    return_val = ['a', 'b', 'c']
    mock_local = mock('local')
    mock_local.stub!(:get_files).and_return(return_val)
    mock_local.should_receive(:get_files)
    Local.stub!(:new).and_return(mock_local)
    Local.should_receive(:new).with(
      instance_of(Array),
      instance_of(Array),
      instance_of(String)
    )
    @upload.get_local_files.should == return_val
  end

end
