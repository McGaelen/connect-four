##
# CIS 343 Connect 4 in Ruby - Game Engine
# Gaelen McIntee
# ?/?/???
#
# This class contains all the game logic for Connect Four in Ruby.
# It also manages an instance of the 'Board' class.
##

require_relative 'Board'

class Engine

    attr_accessor :board, :turn

    def initialize(rows, cols, connect, turn)
        @board = Board.new(rows, cols)
        @connect = connect
        @turn = turn
    end

    # def checkWin()
    #
    # end

    def placeChip(col)
        board.placeChip(col, turn)
    end

    def advance_turn()
        @turn += 1
        if @turn > 2
            @turn = 1
        end
    end




end
