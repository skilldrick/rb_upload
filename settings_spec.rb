require 'settings'

describe Settings, "when initialised" do
  before(:each) do
    @settings = Settings.new
  end

  it "can read properties from yaml" do
    @settings.development['host'].should == 'ftp.bookcraft.co.uk'
  end
  
  it "has different hosts for different sites" do
    development_host = @settings.development['host']
    production_host = @settings.production['host']
    development_host.should == 'ftp.bookcraft.co.uk'
    production_host.should == 'ftp.production.co.uk'
  end

  it "can access netrc" do
    @settings.get_credentials_from_host('ftp.test.co.uk').login.should == 'nick'
  end

  it "gets an array of ignored prefixes" do
    @settings.ignored_prefixes.should have_at_least(2).items
  end
end
