require_relative 'lib/repo'
require_relative 'lib/result_tracker'
require_relative 'lib/lost_file'
require_relative 'lib/algo'

algo = Algo.new(ENV['SOURCE_DIR']).run!
# output lost files for manual processing
puts algo.lost_files
