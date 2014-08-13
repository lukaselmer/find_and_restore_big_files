require_relative 'lib/repo'
require_relative 'lib/result_tracker'
require_relative 'lib/lost_file'

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
