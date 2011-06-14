require 'rb_upload'

describe RbUpload, "when initialised" do
  before(:all) do
    @upload = RbUpload.new
  end

  it "reads property from yaml" do
    @upload.settings['host'].should == 'www.test.co.uk'
  end

  it "can access netrc" do
    @upload.getLogin('www.test.co.uk').should == 'nick'
  end
end
