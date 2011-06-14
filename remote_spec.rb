require 'remote'
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
    @remote.upload('test_files/file1.txt', '/public_html/upload_testing/file1.txt')
  end

  it "should upload binary file" do
    connect
    @remote.upload('test_files/file3.jpg', '/public_html/upload_testing/file3.jpg')
  end

  it "should distinguish ascii from binary files" do
    @remote.ascii?('test/text.txt').should == true
    @remote.ascii?('test/image.jpg').should == false
  end
end
