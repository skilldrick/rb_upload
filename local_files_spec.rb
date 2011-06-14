require 'local_files'

describe LocalFiles do
  before(:each) do
    @local_files = LocalFiles.new ['ignored_dir'], ['.swp'], 'test_files'
  end

  it "should load a list of files in specified directory" do
    files = @local_files.get_files
    files.should have_at_least(1).items
  end

  it "should ignore ignored prefixes" do
    @local_files.ignore?('test_files/ignored_dir/testfile.txt').should == true
    @local_files.ignore?('test_files/not_ignored_dir/testfile.txt').should == false
  end

  it "should ignore ignored prefxes" do
    files = @local_files.get_files
    files.should_not include 'test_files/ignored_dir/file6.txt'
    files.should include 'test_files/dir1/file4.txt'
  end

  it "should ignore ignored suffixes" do
    files = @local_files.get_files
    files.should_not include 'test_files/file.swp'
    files.should include 'test_files/file.swp.txt'
  end
end

