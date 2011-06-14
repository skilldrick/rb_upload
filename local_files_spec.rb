require 'local_files'

describe LocalFiles do
  before(:each) do
    @local_files = LocalFiles.new
  end

  it "should load a list of files in specified directory" do
    files = @local_files.get_files 'test_files'
    files.count.should have_at_least(1).items
  end
end

