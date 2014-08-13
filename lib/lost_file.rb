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
