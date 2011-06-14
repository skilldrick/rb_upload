require 'rb_upload'

describe RbUpload, "#yaml" do
  it "reads property from yaml" do
    upload = RbUpload.new
    upload.settings['host'].should == 'www.test.co.uk'
  end
end

