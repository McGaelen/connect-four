#!/bin/env ruby

##
# CIS 343 Connect Four in Ruby - main program file
# Gaelen McIntee
# ?/?/???
#
# Connect Four: Place 4 tiles in a row vertically, horizontally, or diagonally to win.
##

require_relative 'Board'
require_relative 'Engine'
require_relative 'Arguments'


args = Arguments.new(ARGV)
ARGV.clear # If Arguments.parse fails, clear ARGV to avoid reading stray input

game = Engine.new(args.rows, args.cols, args.connect, 1)
puts args.to_s
puts game.board.to_s

while true
    print "(connect4-p#{game.turn}) "
	input = gets
    input.chomp!

    # User wants to quit
    if input == 'q' or input == 'Q'
        puts "Goodbye!"
        exit

    # User wants to print out the board
    elsif input == 'p' or input == 'P' or input == 'print'
        puts game.board.to_s

	# TODO User wants to load the game board from a file
	elsif input == 'l' or input == 'L' or input == 'load'
		puts "My programmer hasn't given me the ability to load yet!"

	# TODO User wants to save the game board to a file
	elsif input == 's' or input == 'S' or input == 'save'
		puts "My programmer hasn't given me the ability to save yet!"

    # User wants to place a chip
	elsif input =~ /\d+/ # input is a number and not any other command
        begin
        	game.placeChip(input.to_i)
            puts game.board.to_s
            game.advance_turn
        rescue Exception => e
            puts e.message
        end

    # User typed in garbage
    else
        puts "Unrecognized input."
    end
end
