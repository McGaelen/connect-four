##
# CIS 343 Connect Four in Ruby - Blocking AI
# Gaelen McIntee
# 3/29/2017
#
# This AI is designed to block any attempt by the player to win the match.
# It doesn't try to win for itself at all, although that may happen by chance.
#
# This is not a very good AI. But it does play the game, and does more just pick a random column.
##

require_relative 'Board'

class AI

    # Checks if a specific column is full.
    def self.checkColFull(board, col)
        return true if board[0][col] != 0
        false  # false is returned here
    end

    # Return a random column to place a chip in.
    def self.getRandomMove(board)
    return if board.checkFull == true
        col = rand(board.cols)
        while board.checkFull == true
            col = rand(board.cols)
        end
        col  # col is returned
    end

    # Calculate a move, or pick a random one if no move is found.
    def self.getMove(opp, board)
    return if board.checkFull == true

        board.each_with_index do |rowArr, ri|
            rowArr.each_with_index do |chip, ci|

                # Back and Up
                if ci-3 >= 0 or ri-3 >= 0
                    if board[ri-1][ci-1] == opp and board[ri-2][ci-2] == opp
                        if board[ri-3][ci-3] == 0 and board[ri-2][ci-3] != 0
                            return ci-3 if checkColFull(board, ci-3) == false
                        end
                    end
                end

                # Back and Down
                if ci-3 >= 0 and ri+3 < board.rows
                    if board[ri+1][ci-1] == opp and board[ri+2][ci-2] == opp
                        if board[ri+3][ci-3] == 0
                            if ri+4 >= board.rows
                                return ci-3 if checkColFull(board, ci-3) == false
    elsif board[ri+4][ci-3] != 0
    return ci-3 if checkColFull(board, ci-3) == false
    end
    end
    end
    end

    # Up
    if ri-3 >= 0 and board[ri-3][ci] == 0 and board[ri-2][ci] == opp and board[ri-1][ci] == opp
    return ci if checkColFull(board, ci) == false
    end

    # Left
    if ci-3 >= 0 and board[ri][ci-3] == 0 and board[ri][ci-2] == opp and board[ri][ci-1] == opp
    if ri+1 >= 6
    return ci-3 if checkColFull(board, ci-3) == false
    elsif board[ri+1][ci-3] != 0
    return ci-3 if checkColFull(board, ci-3) == false
    end
    end

    # Left Mid
    if ci-3 >= 0 and board[ri][ci-3] == opp
    if board[ri][ci-2] == opp
    if ri+1 >= board.rows
    return ci-1 if checkColFull(board, ci-1) == false
    elsif board[ri+1][ci-1] != 0
    return ci-1 if checkColFull(board, ci-1) == false
    end
    elsif board[ri][ci-1] == opp
    if ri+1 >= board.rows
    return ci-2 if checkColFull(board, ci-2) == false
    elsif board[ri+1][ci-2] != 0
    return ci-2 if checkColFull(board, ci-2) == false
    end
    end
    end

    # Back and Up and Mid
    if ci-3 >= 0 and ri-3 >= 0
    if board[ri-3][ci-3] == opp
    if board[ri-2][ci-2] == opp
    if board[ri-1][ci-1] == 0 and board[ri][ci-1] != 0
    return ci-1 if checkColFull(board, ci-1) == false
    end
    end
    if board[ri-1][ci-1] == opp
    if board[ri-2][ci-2] == 0 and board[ri-1][ci-2] != 0
    return ci-2 if checkColFull(board, ci-2) == false
    end
    end
    end
    end

    # Forward and Up and Mid
    if ci+3 < board.cols and ri-3 >= 0
    if board[ri-3][ci+3] == opp
    if board[ri-2][ci+2] == opp
    if board[ri-1][ci+1] == 0 and board[ri][ci+1] != 0
    return ci+1 if checkColFull(board, ci+1) == false
    end
    end
    if board[ri-1][ci+1] == opp
    if board[ri-2][ci+2] == 0 and board[ri-1][ci+2] != 0
    return ci+2 if checkColFull(board, ci+2) == false
    end
    end
    end
    end

            end
        end  # The two loops looping through the board.

        getRandomMove(board)
    end
end # class
