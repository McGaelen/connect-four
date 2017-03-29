##
# CIS 343 Connect 4 in Ruby - Argument Parsing
# Gaelen McIntee
# 3/29/2017
#
# This class uses Ruby's OptionParser class to parse command line arguments.
# It can also set default values if no arguments are given.
##

require 'optparse'

class Arguments
    attr_accessor :rows, :cols, :connect, :ai, :load

	# Set all default values
    def initialize()
        @rows = 7
        @cols = 7
        @connect = 4
        @ai = false
        @load = ""
    end

	# Defines all possible command line options, parses them, and sets the corresponding values.
    def parse(options)

		# OptionParser takes a block that defines all the possible options
        opt_parser = OptionParser.new do |opts|
            opts.banner = "Usage: connect4.rb [options]"

			# Each call to opts.on() defines an option and takes a block that performs an action on the option.
            opts.on("-w", "--width WIDTH", "Set the width (number of columns) of the Connect Four game board.") do |x|
				raise "Invalid argument for option -w" if x.to_i == 0
                @cols = x.to_i
            end

            opts.on("-h", "--height HEIGHT", "Set the height (number of rows) of the Connect Four game board.") do |x|
				raise "Invalid argument for option -h" if x.to_i == 0
                @rows = x.to_i
            end

            opts.on("-s", "--square SQUARE", "Set the width and height of the Connect Four game board.") do |x|
				raise "Invalid argument for option -s" if x.to_i == 0
                @rows = x.to_i
                @cols = x.to_i
            end

            opts.on("-c", "--connect CONNECT", "Set the number of spots in a row needed to win.") do |x|
				raise "Invalid argument for option -c" if x.to_i == 0
                @connect = x.to_i
            end

            opts.on("-l", "--load FILE_PATH", "Load a saved game from a file.") do |x|
				raise "Invalid argument for option -l" if x == ""
                @load = x.to_s
            end

            opts.on("-a", "--ai AI", "(EXPERIMENTAL) Play against an AI.") do |x|
				raise "Invalid argument for option -a" if x == ""
                if x.to_i == 1
                    @ai = true
                else
                    @ai = false
                end
            end

            opts.on("--help", "Print this help message.") do
                puts opts
            end
        end  # Option parser block

		opt_parser.parse(options)
    end
end
