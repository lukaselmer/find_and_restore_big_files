class Repo
  def initialize(source_dir)
    @source_dir = source_dir
  end

  def generate_paths
    # code here
  end

  def generate_hashes
    # code here
  end

  def checkout_older_revision!
    # code here
  end

  def changed_files
    # code here
  end

  def contains_older_revision?
    # code here
  end
end

class RepoFile

end

class LostFiles
  @lost_files = []

  def store(revision, file_path)
    puts "#{file}: #{revision}"
    @lost_files << [revision, file_path]
  end

  def to_s
    @lost_files.map do |revision, file|
      "#{file} #{revision}"
    end.join("\n")
  end
end

class ResultTracker
  def initialize(repo)
    @repo = repo
    @paths = repo.generate_paths
    @hashes = repo.generate_hashes
  end

  def path_exists?(file)
    @paths.include?(file.path)
  end

  def store(file)
    @hashes << file.hash unless @hashes.include?(file.hash)
    @paths << file.path unless @paths.include?(file.path)
  end

  def content_exists?(file)
    # or, better: store hash s.t. compare_files(file1.hash, file2.hash) = true iff file1 is at least 90% similar to file2
    @hashes.any? { |hash| file.hash == hash }
  end
end

source_dir = ENV['SOURCE_DIR']

repo = Repo.new(source_dir)
results = LostFiles.new
result_tracker = ResultTracker.new(repo)


while repo.contains_older_revision? do
  repo.checkout_older_revision!
  repo.changed_files.each do |file| # for every [changed|removed|added]
    begin
      # check if path in a newer version exists
      next if result_tracker.path_exists?(file)

      # check if same / similar file exists
      next if result_tracker.content_exists?(file)

      # if algo gets to here, file is a lost file
      results.store(repo.revision, file.path)
    ensure
      result_tracker.store(file)
    end
  end
end

# output lost files for manual processing
puts results
