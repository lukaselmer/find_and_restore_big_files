RSpec.describe Repo do
  it 'finds the accidentally deleted files' do
    algo = Algo.new(EXAMPLE_REPO_PATH)
    algo.run!
    file_paths = algo.lost_files.map(&:path)
    expect(file_paths).to include('aaa/testfile11.txt', 'xxx/testfile8.txt')
    expect(file_paths.lenght).to eq(2)
  end

end
