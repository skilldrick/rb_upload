require 'remote'
require 'local'
require 'settings'

describe Remote do
  def connect
    settings = Settings.new
    credentials = settings.get_credentials_from_site 'development'
    @remote.connect credentials
  end

  before(:each) do
    @remote = Remote.new
  end

  it "should connect with correct credentials" do
    connect
    @remote.list #force it to do something
  end

  it "should upload ascii file" do
    connect
    local_path = 'test_files/file1.txt'
    remote_path = '/public_html/upload_testing/file1.txt'
    @remote.upload(local_path, remote_path)
    local_size = Local.filesize local_path
    remote_size = @remote.filesize remote_path
    local_size.should == remote_size
  end

  it "should upload binary file" do
    connect
    local_path = 'test_files/file3.jpg'
    remote_path = '/public_html/upload_testing/file3.jpg'
    @remote.upload(local_path, remote_path)
    local_size = Local.filesize local_path
    remote_size = @remote.filesize remote_path
    local_size.should == remote_size
  end

  it "should distinguish ascii from binary files" do
    @remote.ascii?('test/text.txt').should == true
    @remote.ascii?('test/image.jpg').should == false
  end

  it "should be able to see whether directories exist" do
    connect
    does_exist = '/public_html'
    does_not_exist = '/blahdiblahblah'
    @remote.dir_exists?(does_exist).should == true
    @remote.dir_exists?(does_not_exist).should == false
  end

  it "should make directory" do
    connect
    remote_path = '/public_html/upload_testing/testdir'
    @remote.make_dir remote_path
    @remote.dir_exists?(remote_path).should == true
  end
end
