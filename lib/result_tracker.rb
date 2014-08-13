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
    hash = @repo.generate_hash(file.path)
    @hashes << hash unless @hashes.include?(hash)
    @paths << file.path unless @paths.include?(file.path)
  end

  def content_exists?(file)
    # or, better: store hash s.t. compare_files(file1.hash, file2.hash) = true iff file1 is at least 90% similar to file2
    @hashes.any? { |hash| @repo.generate_hash(file.path) == hash }
  end
end
