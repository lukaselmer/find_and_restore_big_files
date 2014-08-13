class LostFiles
  LostFile = Struct.new(:revision, :path)

  attr_reader :all

  def initialize
    @all = []
    @all << LostFile.new('some-revision', 'xxx/testfile8.txt')
    @all << LostFile.new('some-other-revision', 'aaa/testfile11.txt')
  end

  def store(revision, file_path)
    puts "#{file}: #{revision}"
    @all << LostFile.new(revision, file_path)
  end

  def to_s
    @all.map do |lost_file|
      "#{lost_file.revision} #{lost_file.path}"
    end.join("\n")
  end
end
