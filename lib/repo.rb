require 'rugged'

class Repo
  RepoFile = Struct.new(:commit, :path)

  def initialize(source_dir)
    raise Exception.new("Source dir #{source_dir} does not exist") unless Dir.exist?(source_dir)

    @source_dir = source_dir
    @rugged_repo = Rugged::Repository.new(@source_dir)
    @previous_commit = @current_commit = nil

    checkout_master!
  end

  def generate_paths
    require 'pathname'
    Dir.glob("#{@source_dir}/**/*").select do |path|
      File.file?(path)
    end.map do |path|
      Pathname.new(path).relative_path_from(Pathname.new(@source_dir)).to_s
    end
  end

  def generate_hashes
    generate_paths.map do |path|
      generate_hash(path)
    end
  end

  def generate_hash(path)
    Digest::MD5.file("#{@source_dir}/#{path}").hexdigest
  end

  def checkout_older_revision!(commit)
    @previous_commit = @current_commit || commit
    @current_commit = commit

    `cd #{@source_dir} && git checkout #{@previous_commit.oid} 2>&1`
    #@rugged_repo.checkout(@current_commit.oid)
  end

  def changed_files
    # diff.find_similar! could be useful here...
    #p @current_commit.diff(@previous_commit).deltas #.collect(&:status)
    @current_commit.diff(@previous_commit).deltas.reject do |delta|
      # %i(added modified).include? delta.status
      delta.status == :deleted
    end.map do |d|
      RepoFile.new(@current_commit.oid, d.old_file[:path])
    end
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
