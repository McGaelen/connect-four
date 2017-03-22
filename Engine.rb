##
# CIS 343 Connect 4 in Ruby - Game Engine
# Gaelen McIntee
# ?/?/???
#
# This class contains all the game logic for Connect Four in Ruby.
# It also manages an instance of the 'Board' class.
##

#TODO:
#✅    Record which case won
#✅    Fix fourth case
require 'pry'
require_relative 'Board'

class Engine

    attr_accessor :rows, :cols, :board, :turn, :connect, :ai, :winner, :winCase

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

    def checkWin()

        @board.each_with_index do |rowArr, ri|   # rowArr is an Array
            rowArr.each_with_index do |chip, ci| # chip is an Integer
                # puts "In checkWin loop: @board[#{ri}][#{ci}]"
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

            end
        end

        false
    end

    def placeChip(col)
        board.placeChip(col, turn)
    end

    def advance_turn()
        @turn += 1
        if @turn > 2
            @turn = 1
        end
    end

    def reset()
        @board = Board.new(rows, cols)
        @turn = 1
        @winner = 0
    end

    def self.load(filename)
        loadfile = File.open(filename)
        Marshal.load(loadfile)
    end

    def save(filename)
        savefile = File.open(filename, "w")
        Marshal.dump(self, savefile)
    end

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
