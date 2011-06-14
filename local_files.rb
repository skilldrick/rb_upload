class LocalFiles
  attr_accessor :ignored_prefixes, :ignored_suffixes

  def initialize ignored_prefixes, ignored_suffixes, directory
    @ignored_prefixes = ignored_prefixes
    @ignored_suffixes = ignored_suffixes
    @directory = directory
    @ignored_prefixes.map! { |prefix| File.join(@directory, prefix) }
  end

  def ignore? file_path
    file_path.start_with?(*@ignored_prefixes) || file_path.end_with?(*@ignored_suffixes)
  end

  def get_files
    files = Dir["#{@directory}/**/*.*"] #get all files recursively
    files = files.reject do |file|
      ignore? file
    end
    files
  end
end
