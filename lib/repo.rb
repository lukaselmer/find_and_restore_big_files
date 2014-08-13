require 'rugged'

class Repo
  def initialize(source_dir)
    raise Exception.new("Source dir #{source_dir} does not exist") unless Dir.exist?(source_dir)

    @source_dir = source_dir
    @rugged_repo = Rugged::Repository.new(@source_dir)

    checkout_master!
  end

  def generate_paths
    Dir.glob("#{@source_dir}/**/*").select do |path|
      File.file?(path)
    end
  end

  def generate_hashes
    generate_paths.map do |path|
      Digest::MD5.file(path).hexdigest
    end
  end

  def checkout_older_revision!(commit)
    #p commit
    # code here
  end

  def changed_files
    # code here
  end

  def each_commit(&block)
    walker = Rugged::Walker.new(@rugged_repo)
    walker.sorting(Rugged::SORT_TOPO)
    walker.push('master')
    walker.each(&block)
    walker.reset
  end

  private

  def checkout_master!
    @rugged_repo.checkout('master')
  end

end

class RepoFile

end

