class Repo
  def initialize(source_dir)
    @source_dir = source_dir
    `cd #{source_dir} && git checkout master`

  end

  def generate_paths
    # code here
  end

  def generate_hashes
    # code here
  end

  def checkout_older_revision!
    # code here
  end

  def changed_files
    # code here
  end

  def contains_older_revision?
    # code here
  end
end

class RepoFile

end

