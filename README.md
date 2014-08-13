Find and restore big files
==========================

Usage
-----

SOURCE_DIR=/path/to/git/repo bundle exec ruby run.rb


Problem
-------

You have a directory with many large files. Sometimes, files in this directory are deleted accidentally.
That's why you decided to write the following "backup script":

```sh
rsync -av --delete-after ~/interesting_dir ~/git_repo
cd ~/git_repo
git pull origin master
git add -A .
git commit -m "auto commit $(date) $(git status)"
git push origin master
```

Now, you would like to restore these deleted files :)


Ideas and Observations
----------------------

There is only one branch, and thus commits are all in sequence (no merges, clear before/after commit).

Files may change in this ~/interesting_dir. Therefore you would like to ignore the following old files:

* Files with the same path (including file name) [files which have been updated]
* Files which are in a later revision the same (have the same (md5|sha1|whatever) hash) [removed, and then re-added]
* (optional) Files which are to 90% similar [files which have been updated]

Solution
--------

<pre>
paths = generate paths of all files of the latest revision
hashes = init hashes of all files
# or, better: store hash s.t. compare_files(file1.hash, file2.hash) = true iff file1 is at least 90% similar to file2
lost files = []

while(has older revision) do
  checkout older revision
  for every [changed|removed|added] file do |file|
  
    # check if path in a newer version exists
    if file.path in paths
      add file.hash to hashes
      continue
    end
    
    # check if same / similar file exists
    if any(hashes, (hash) -> compare_files(file.hash, hash))
      add file.path to paths
      continue
    end
    
    # if algo gets to here, file is a lost file
    add (revision, file path) to lost files
    add file.path to paths
    add file.hash to hashes
    
  end
end

output lost files for manual processing
</pre>
