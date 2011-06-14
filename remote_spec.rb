require 'remote'
require 'settings'

describe Remote do
  before(:each) do
    @remote = Remote.new
  end

  it "should connect with correct credentials" do
    settings = Settings.new
    credentials = settings.get_credentials_from_site 'development'
    @remote.connect credentials
  end
end

