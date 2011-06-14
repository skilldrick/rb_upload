class Local
  attr_accessor :ignored_prefixes, :ignored_suffixes

  def initialize ignored_prefixes, ignored_suffixes, directory
    @ignored_prefixes = ignored_prefixes
    @ignored_suffixes = ignored_suffixes
    @directory = directory
  end

  def filesize path
    File.size path
  end

  def ignore? path
    path.start_with?(*@ignored_prefixes) || path.end_with?(*@ignored_suffixes)
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
