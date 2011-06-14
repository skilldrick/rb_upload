require 'local'

describe Local do
  before(:each) do
    @local = Local.new ['ignored_dir'], ['.swp'], 'test_files'
  end

  it "should load a list of files in specified directory" do
    files = @local.get_files
    files.should have_at_least(1).items
  end

  it "should ignore ignored prefixes" do
    @local.ignore?('ignored_dir/testfile.txt').should == true
    @local.ignore?('not_ignored_dir/testfile.txt').should == false
  end

  it "should ignore ignored prefxes" do
    files = @local.get_files
    files.should_not include 'ignored_dir/file6.txt'
    files.should include 'dir1/file4.txt'
  end

  it "should ignore ignored suffixes" do
    files = @local.get_files
    files.should_not include 'file.swp'
    files.should include 'file.swp.txt'
  end

  it "should get size of file" do
    Local.filesize('test_files/file1.txt').should == 22
  end
end

