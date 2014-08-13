class Repo

end

class RepoFile

end

class Results
  @lost_files = []

  def to_s
    @lost_files.map do |revision, file|
      "#{file} #{revision}"
    end.join("\n")
  end

  def store_lost_file(revision, file_path)
    puts "#{file}: #{revision}"
    @lost_files << [revision, file_path]
  end
end

source_dir = ENV['SOURCE_DIR']
#out_dir = ENV['OUT_DIR']

repo = Repo.new(source_dir)
results = Results.new

paths = repo.generate_paths
hashes = repo.generate_hashes
# or, better: store hash s.t. compare_files(file1.hash, file2.hash) = true iff file1 is at least 90% similar to file2

while (repo.contains_older_revision?) do
  repo.checkout_older_revision!
  repo.changed_files.each do |file| # for every [changed|removed|added]

    # check if path in a newer version exists
    if paths.include?(file.path)
      hashes << file.hash
      next
    end

    # check if same / similar file exists
    if hashes.any?(-> (hash) { compare_files(file.hash, hash) })
      paths << file.path
      next
    end

    # if algo gets to here, file is a lost file
    results.store_lost_file(repo.revision, file.path)
    hashes << file.hash
    paths << file.path
  end
end

# output lost files for manual processing
puts results
