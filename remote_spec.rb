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

  after(:each) do
    @remote.close
  end

  it "should connect with correct credentials" do
    connect
    @remote.list #force it to do something
  end

  it "should upload ascii file" do
    connect
    local_path = 'test_files/file1.txt'
    remote_path = '/public_html/upload_testing/file1.txt'
    same_size = @remote.upload(local_path, remote_path, :check_size)
    same_size.should == true
  end

  it "should upload binary file" do
    connect
    local_path = 'test_files/file3.jpg'
    remote_path = '/public_html/upload_testing/file3.jpg'
    same_size = @remote.upload(local_path, remote_path, :check_size)
    same_size.should == true
  end

  it "should distinguish ascii from binary files" do
    @remote.ascii?('test/text.txt').should == true
    @remote.ascii?('test/image.jpg').should == false
  end

  it "should be able to see whether directories exist" do
    connect
    does_exist = '/public_html'
    does_not_exist = '/blahdiblahblah'
    @remote.exists?(does_exist).should == true
    @remote.exists?(does_not_exist).should == false
  end

  it "should be able to see whether files exist" do
    connect
    does_exist = '/public_html/upload_testing/image.jpg'
    does_not_exist = '/public_html/upload_testing/blahblahblah.jpg'
    @remote.upload('test_files/file3.jpg', does_exist)
    @remote.exists?(does_exist).should == true
    @remote.exists?(does_not_exist).should == false
  end

  it "should make directory" do
    connect
    remote_path = '/public_html/upload_testing/testdir'
    @remote.make_dir remote_path
    @remote.exists?(remote_path).should == true
  end

  it "should make directories recursively" do
    connect
    remote_path = '/public_html/upload_testing/a/b/c/d/e'
    @remote.make_dir remote_path
    @remote.exists?(remote_path).should == true
    @remote.remove_dir('/public_html/upload_testing/a')
  end

  it "should remove a file" do
    connect
    local_path = 'test_files/file3.jpg'
    remote_path = '/public_html/upload_testing/image.jpg'

    @remote.upload(local_path, remote_path)
    @remote.exists?(remote_path).should == true
    @remote.remove_file(remote_path)
    @remote.exists?(remote_path).should == false
  end

  it "should remove a directory" do
    connect
    remote_path = '/public_html/upload_testing/testdir'
    @remote.make_dir remote_path
    @remote.make_dir File.join(remote_path, 'subdir')
    @remote.upload('test_files/file3.jpg', File.join(remote_path, 'subdir', 'image.jpg'))
    @remote.remove_dir remote_path
    @remote.exists?(remote_path).should == false
  end

  it "should create a directory for a file if needed" do
    connect
    @remote.remove_dir '/public_html/upload_testing/testdir'
    remote_path = '/public_html/upload_testing/testdir/anotherdir/image.jpg'
    @remote.upload('test_files/file3.jpg', remote_path)
    @remote.exists?(remote_path).should == true
  end
end
