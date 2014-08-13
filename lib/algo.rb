class Algo
  attr_reader :lost_files

  def initialize(source_dir)
    @source_dir = source_dir
    @repo = Repo.new(@source_dir)
    @result_tracker = ResultTracker.new(@repo)
    @lost_files = LostFiles.new
  end

  def run!
    @repo.each_commit do |commit|
      @repo.checkout_older_revision!(commit)

      @repo.changed_files.each do |file| # for every [changed|removed|added]
        begin
          # check if path in a newer version exists
          next if @result_tracker.path_exists?(file)

          # check if same / similar file exists
          next if @result_tracker.content_exists?(file)

          # if algo gets to here, file is a lost file
          @lost_files.store(@repo.revision, file.path)
        ensure
          @result_tracker.store(file)
        end
      end
    end
  end
end
