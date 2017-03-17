##
# CIS 343 Connect 4 in Ruby - Argument Parsing
# Gaelen McIntee
# ?/?/???
#
# This class uses Ruby's OptionParser class to parse command line arguments.
# It can also set default values if no arguments are given, and it can print out
# all arguments.
##

require 'optparse'

class Arguments
    attr_accessor :rows, :cols, :connect, :ai, :load

    def initialize(arguments)
        @rows = 7
        @cols = 7
        @connect = 4
        @ai = false
        @load = nil
        parse(arguments)
    end

    def parse(options)

        opt_parser = OptionParser.new do |opts|
            opts.banner = "Usage: connect4.rb [options]"

            opts.on("-wWIDTH", "--width=WIDTH", "Set the width (number of columns) of the Connect Four game board.") do |x|
                @cols = x.to_i
            end

            opts.on("-hHEIGHT", "--height=height", "Set the height (number of rows) of the Connect Four game board.") do |x|
                @rows = x.to_i
            end

            opts.on("-sSQUARE", "--square=SQUARE", "Set the width and height of the Connect Four game board.") do |x|
                @rows = x.to_i
                @cols = x.to_i
            end

            opts.on("-cCONNECT", "--connect=CONNECT", "Set the number of spots in a row needed to win.") do |x|
                @connect = x.to_i
            end

            opts.on("-lLOAD", "--load=FILE_PATH", "Load a saved game from a file.") do |x|
                @load = x
            end

            opts.on("-aAI", "--ai=AI", "(EXPERIMENTAL) Play against an AI.") do |x|
                if x == 1
                    @ai = true
                elsif x == 0
                    @ai = false
                end
            end

            opts.on("--help", "Print this help message.") do
                puts opts
                exit
            end
        end

		begin
			opt_parser.parse!(options)
		rescue OptionParser::InvalidOption => e
			puts "Invalid option, consider using '--help'."
			puts "All following options ignored."
		end
    end

    def to_s()
		[
			"Rows: #{@rows}",
    		"Cols: #{@cols}",
        	"Connects: #{@connect}",
        	"Load file: #{@load}",
        	"AI: #{@ai}\n",
        	"Game Start!"
		].join("\n")
		# entire string is returned
    end
end
