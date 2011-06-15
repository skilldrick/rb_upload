require 'rb_upload'
require 'local'
require 'remote'

describe RbUpload do
  before(:each) do
    @upload = RbUpload.new
  end

  after(:each) do
    @upload.close
  end

  it "should pass correct params to LocalFiles" do
    return_val = ['a', 'b', 'c']
    mock_local = mock('local')
    mock_local.stub!(:get_files).and_return(return_val)
    Local.stub!(:new).and_return(mock_local)
    Local.should_receive(:new).with(
      instance_of(Array),
      instance_of(Array),
      instance_of(String)
    )
    @upload.init_local
  end

  it "should pass correct paths to remote#upload" do
    path_from_local = 'dir1/file4.txt'
    mock_remote = mock('remote')
    mock_remote.should_receive(:upload).with(
      'test_files/dir1/file4.txt',
      '/public_html/upload_testing/dir1/file4.txt',
      :check_size
    )
    mock_remote.should_receive(:connect)
    mock_remote.should_receive(:close)
    Remote.stub!(:new).and_return(mock_remote)
    @upload.init_local
    @upload.init_remote
    @upload.upload(path_from_local)
  end

  it "should upload all files from list_remote" do
    mock_remote = mock('remote')
    mock_remote.should_receive(:upload).exactly(3).times
    mock_remote.should_receive(:connect)
    mock_remote.should_receive(:close)
    Remote.stub!(:new).and_return(mock_remote)

    return_val = ['a', 'b', 'c']
    mock_local = mock('local')
    mock_local.stub!(:get_files).and_return(return_val)
    mock_local.stub!(:get_relative_path)
    Local.stub!(:new).and_return(mock_local)

    @upload.upload_all
  end
end
