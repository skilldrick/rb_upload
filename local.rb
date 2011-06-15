class Local
  def initialize ignored_prefixes, ignored_suffixes, directory
    @ignored_prefixes = ignored_prefixes
    @ignored_suffixes = ignored_suffixes
    @directory = directory
  end

  def self.filesize path
    File.size path
  end

  def self.modified_time path
    File.mtime path
  end

  def ignore? path
    path.start_with?(*@ignored_prefixes) || path.end_with?(*@ignored_suffixes)
  end

  def get_relative_path path
    File.join @directory, path
  end

  def get_files
    Dir.chdir @directory do
      files = Dir["**/*.*"] #get all files recursively
      files = files.reject do |file|
        ignore? file
      end
      files
    end
  end
end
