require 'logger'

RSpec.describe Repo do
  it 'finds the accidentally deleted files' do
    algo = Algo.new(EXAMPLE_REPO_PATH, Logger.new(STDOUT))
    algo.run!
    file_paths = algo.lost_files.all.map(&:path)
    expect(file_paths).to include('aaa/testfile11.txt', 'xxx/testfile8.txt')
    expect(file_paths.size).to eq(2)
  end

end
