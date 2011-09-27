#requires a relative path when script is executed possibly via a symlink
def relative_require path
  realpath = Pathname.new(__FILE__).realpath #follow symlink
  require File.expand_path("../#{path}", realpath)
end

relative_require 'settings'

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

  it "can set and read lastrun" do
    time = Time.now.utc
    @settings.lastrun['development'] = time
    @settings.lastrun['development'].should be_within(1).of(time) #time gets rounded in @settings
  end

  it "returns -1 when no lastrun" do
    File.delete '.lastrun_development'
    File.delete '.lastrun_production'
    @settings.lastrun['development'].should == -1
    @settings.lastrun['production'].should == -1
  end

  it "should have separate .lastrun for each site" do
    time1 = Time.now.utc
    time2 = Time.now.utc + 20
    @settings.lastrun['development'] = time1
    @settings.lastrun['production'] = time2
    @settings.lastrun['development'].should be_within(1).of(time1)
    @settings.lastrun['production'].should be_within(1).of(time2)
  end
end
