class LostFiles
  LostFile = Struct.new(:revision, :path)

  attr_reader :all

  def initialize(logger)
    @logger = logger
    @all = []
  end

  def store(file)
    @logger.info("Lost file found: #{file.commit}: #{file.path}")
    @all << LostFile.new(file.commit, file.path)
  end

  def to_s
    @all.map do |lost_file|
      "#{lost_file.revision} #{lost_file.path}"
    end.join("\n")
  end
end
