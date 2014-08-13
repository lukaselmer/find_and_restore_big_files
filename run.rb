require 'logger'
require_relative 'lib/repo'
require_relative 'lib/result_tracker'
require_relative 'lib/lost_file'
require_relative 'lib/algo'

logger = Logger.new(STDOUT)
algo = Algo.new(ENV['SOURCE_DIR'], logger).run!
# output lost files for manual processing
logger.info(algo.lost_files.to_s)
