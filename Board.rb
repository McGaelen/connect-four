##
# CIS 343 Connect 4 in Ruby - Game Board
# Gaelen McIntee
# 3/29/2017
#
# This class holds a 2d array of Integers that represent the game board.
# It also manages placing chips, checking if it's full and printing it out.
##

require 'colorize'

class Board

    attr_accessor :board, :rows, :cols

    def initialize(rows=7, cols=7)
    @rows = rows
    @cols = cols
    # Creates a new Array with each spot initialized to another Array initialized to 0.
    @board = Array.new(rows){ Array.new(cols, 0) }
    end

    # Places a chip in the given column according to the given player.
    # Can raise an execption if the column number is invalid or the column is full.
    def placeChip(col, player)
    # Set the column to the right index
    col -= 1

    # Detect invalid input
    if col < 0 or col >= @cols
    raise "Invalid column number."
    elsif @board[0][col] != 0
    raise "Column is full."
    else
    # Loop through each row in the given column
    @board.each_with_index do |r, ind|
    # If we're at the bottom row, or the row below contains a chip
    if ind == (@rows-1) or @board[ind+1][col] != 0
    @board[ind][col] = player  # Set this spot as the player's
    break
    end
    end
    end
    end # placeChip

    # Checks if the board is full.
    # This only checks the top row, since the board is only full
    # when the top spot in each column is occupied.
    def checkFull()
    @board[0].each do |c|
    if c == 0
    return false
    end
    end

    return true
    end

    # Gives access to the .each method on the internal board array.
    def each(&block)
    @board.each(&block)
    end

    # Gives access to the .each_with_index method on the internal board array.
    def each_with_index(&block)
    @board.each_with_index(&block)
    end

    # Returns the internal array at the index provided.
    # Allows us to reference the internal board array with bracket notation
    # outside the scope of this class.
    def [](row)
    @board[row]
    end

    # Prints the entire board with colors.
    def to_s()
    s = "\n"
    for r in @board
    for c in r
    case c
    when 0
    s << "-  ".blue
    when 1
    s << "#{c}  ".cyan
    when 2
    s << "#{c}  ".yellow
    end
    end
    s << "\n"
    end
    s # s is returned
    end # to_s

end # Class
