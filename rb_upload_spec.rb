#requires a relative path when script is executed possibly via a symlink
def relative_require path
  realpath = Pathname.new(__FILE__).realpath #follow symlink
  require File.expand_path("../#{path}", realpath)
end

relative_require 'rb_upload'
relative_require 'local'
relative_require 'remote'

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

  it "should check lastrun if comparison_mode is lastrun" do
    mock_lastrun = mock('lastrun')
    mock_lastrun.should_receive(:[]).any_number_of_times.and_return(Time.now)
    @upload.settings.stub!(:lastrun).and_return(mock_lastrun)
    @upload.comparison_mode = :lastrun
    @upload.init_local
    Local.stub!(:modified_time).and_return(Time.now - 1)
    @upload.init_remote
    @upload.skip?('test_files/file1.txt').should == true
  end

  it "should set lastrun after completion" do
    mock_remote = mock('remote')
    mock_remote.should_receive(:upload).any_number_of_times
    mock_remote.should_receive(:connect)
    mock_remote.should_receive(:close)
    Remote.stub!(:new).and_return(mock_remote)
    mock_lastrun = mock('lastrun')
    mock_lastrun.should_receive(:[]=).exactly(1).times
    @upload.settings.stub!(:lastrun).and_return(mock_lastrun)
    @upload.upload_all
  end

  it "should use filesize comparison if no lastrun" do
    mock_lastrun = mock('lastrun')
    mock_lastrun.should_receive(:[]).and_return(-1)
    @upload.settings.stub!(:lastrun).and_return(mock_lastrun)
    @upload.comparison_mode = :lastrun
    @upload.comparison_mode.should == :filesize
  end
end
