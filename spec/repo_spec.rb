RSpec.describe Repo do
  it 'checks out master when initialized' do
    Repo.new(EXAMPLE_REPO_PATH)
    expect(`cd #{EXAMPLE_REPO_PATH} && git status`).to start_with('On branch master')
  end

  it 'generates the paths of all files in the repo' do
    repo = Repo.new(EXAMPLE_REPO_PATH)
    paths = repo.generate_paths
    expect(paths.length).to eq(10)
    expect(paths).to include("#{EXAMPLE_REPO_PATH}/README.md", "#{EXAMPLE_REPO_PATH}/xxx/testfile5.txt")
  end


  it 'should iterate over the commits' do
    repo = Repo.new(EXAMPLE_REPO_PATH)

    commits = []
    repo.each_commit do |commit|
      commits << commit
    end

    expect(commits.size).to eq(14)
    expect(commits.first.message).to eq("readme\n")
    expect(commits.last.message).to eq("initial commit\n")
    expect(commits.map(&:message)).to include("rename testfile 10\n")
    expect(commits.map(&:message)).to include("accidental removal of file 8\n")
  end
end
