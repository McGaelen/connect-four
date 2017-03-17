##
# CIS 343 Connect 4 in Ruby - Game Board
# Gaelen McIntee
# ?/?/???
#
# This class holds a 2d array of fixnums that represent the game board.
# It also manages placing chips, checking if it's full and printing it out.
##

class Board

	def initialize(rows=7, cols=7)
		@rows = rows
		@cols = cols
		@board = Array.new(rows){ Array.new(cols, 0) }
	end

	def placeChip(col, player)
		col -= 1

		if col < 0 or col >= @cols
			raise "Invalid column number."
		elsif @board[0][col] != 0
			raise "Column is full."
		else
			@board.each_with_index do |r, ind|
				if ind == (r.size-1) or @board[ind+1][col] != 0
					@board[ind][col] = player
				end
			end
		end
	end

	def checkFull()
		@board[0].each do |c|
			if c == 0
				return false
			end
		end

		return true
	end

	def to_s()
		s = "\n"
		for r in @board
			for c in r
				if c == 0
					s << "-  "
				else
					s << "#{c}  "
				end
			end
			s << "\n"
		end
		s # s is returned
	end

end #Class
