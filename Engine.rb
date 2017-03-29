##
# CIS 343 Connect 4 in Ruby - Game Engine
# Gaelen McIntee
# 3/29/2017
#
# This class contains all the game logic for Connect Four in Ruby.
# It also manages an instance of the 'Board' class.
##


require_relative 'Board'

class Engine

    attr_accessor :rows, :cols, :board, :turn, :connect, :ai, :winner, :winCase

	# Initialize everything to default values and make a new Board instance
    def initialize(rows, cols, connect, turn, ai)
        @rows = rows
        @cols = cols
        @board = Board.new(rows, cols)
        @connect = connect
        @turn = turn
        @ai = ai
        @winner = 0
        @winCase = ""
    end

	# Check the board for a win.  The algorithm checks for 4 cases:
	# => Horizontal case
	# => Vertical case
	# => Diagonal (Up and to the Right) case
	# => Diagonal (Up and to the Left) case
	# True is returned if there is a winner, false if no winner is detected.
	# If a winner is detected, the winner and the case that was triggered are recorded.
    def checkWin()
		# Looping through each spot one by one
        @board.each_with_index do |rowArr, ri|   # rowArr is an Array
            rowArr.each_with_index do |chip, ci| # chip is an Integer

                offset = 0
                next if chip == 0

                # Horizontal Case: Iterates to the right of the current
                # cell as long as the current cell is the same as the
                # previous, up to @connect times.
                for col in ci..(@cols-1)
                    break if rowArr[col] != chip

                    if col == (ci+@connect-1)
                        @winner = chip
                        @winCase = "Horizonal Win"
                        return true
                    end
                end

                # Vertical Case: Same as the horizontal case, but
                # iterates downard from the current cell.
                for row in ri..(@rows-1)
                    break if @board[row][ci] != chip

                    if row == (ri+@connect-1)
                        @winner = chip
                        @winCase = "Vertical Win"
                        return true
                    end
                end

                # Up and Right Case: Iterates to the right, but keeps
                # track of an offset that also raises the index up one
                # row, to check diagonally.
                for col in ci..(@cols-1)
                    break if @board[ri-offset][col] != chip

                    if col == (ci+@connect-1)
                        @winner = chip
                        @winCase = "Diagonal (Up and to the Right) Win"
                        return true
                    end
                    offset += 1
                end

                # Up and Left case: Similar to up and right, this
                # keeps an offset for the row, but iterates to the left
                # instead.
                offset = 0
                (ci).downto(0).each do |col|
                    break if @board[ri-offset][col] != chip

                    if col == (ci-@connect+1)
                        @winner = chip
                        @winCase = "Diagonal (Up and to the Left) Win"
                        return true
                    end
                    offset += 1
                end

            end # rowArr.each_with_index
        end # @board.each_with_index

        false  # return val
    end  # checkWin

	# Provides access to Board's placeChip method.
	# No turn needs to be provided, since the Engine already knows
	# who's turn it is.
    def placeChip(col)
        board.placeChip(col, turn)
    end

	# Move the turn to the next person.
    def advance_turn()
        @turn += 1
        if @turn > 2
            @turn = 1
        end
    end

	# Reset the game by recreating the board and resetting the turn, winner, and winCase
    def reset()
        @board = Board.new(rows, cols)
        @turn = 1
        @winner = 0
		@winCase = ""
    end

	# Static method that loads a game from the provided filename.
	# Returns the loaded object.
	# Since it's static, we can load a game from an uninitialized state.
	# Will throw an exception if the loaded object is not an Engine.
    def self.load(filename)
        loadfile = File.open(filename)
        game = Marshal.load(loadfile)
		if !game.is_a? Engine
			raise "#{filename} is not a valid Connect Four file"
		end
		game # this value is returned, if execption not raised.
    end

	# Dumps this object to a file.
    def save(filename)
        savefile = File.open(filename, "w")
        Marshal.dump(self, savefile)
    end

	# Returns a string with all the parameters associated with this Engine.
    def to_s()
        [
			"Rows: #{@rows}",
    		"Cols: #{@cols}",
        	"Connects: #{@connect}",
        	"AI: #{@ai}\n",
		].join("\n")
		# entire string is returned
    end
end
