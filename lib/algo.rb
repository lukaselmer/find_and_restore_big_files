class Algo
  attr_reader :lost_files

  def initialize(source_dir)
    @source_dir = source_dir
    @lost_files = nil
  end

  def run!
    repo = Repo.new(@source_dir)
    @lost_files = LostFiles.new
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
          @lost_files.store(repo.revision, file.path)
        ensure
          result_tracker.store(file)
        end
      end
    end
  end
end
