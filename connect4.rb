#!/bin/env ruby

##
# CIS 343 Connect Four in Ruby - main program file
# Gaelen McIntee
# ?/?/???
#
# Connect Four: Place 4 tiles in a row vertically, horizontally, or diagonally to win.
##

# TODO:
#✅   notify user which win case triggered
#✅   add colors to output
#✅    Have board use entire screen


require 'colorize'
require 'pry'
require_relative 'Engine'
require_relative 'Arguments'


system "clear"
system "tput cup 0 0"

feedback = ""

args = Arguments.new
begin
    args.parse(ARGV)
rescue Exception => e
    feedback << e.message.light_red << ". Consider using '--help'. ".light_red << "All following options ignored.".light_red
end

ARGV.clear # If Arguments.parse fails, clear ARGV to avoid reading stray input

game = Engine.new(args.rows, args.cols, args.connect, 1, args.ai)

if args.load != ""
    begin
        game = Engine.load(args.load)
        feedback << "File \"#{args.load}\" loaded.\n".light_green
    rescue Errno::ENOENT => e
        feedback << e.message.light_red << "\nUsing default settings.\n".light_red
    end
end

# Ascii art generated at http://patorjk.com/software/taag/ using the "Slant" font
banner = [
    '    ______                            __     ______                ',
    '   / ____/___  ____  ____  ___  _____/ /_   / ____/___  __  _______',
    '  / /   / __ \/ __ \/ __ \/ _ \/ ___/ __/  / /_  / __ \/ / / / ___/',
    ' / /___/ /_/ / / / / / / /  __/ /__/ /_   / __/ / /_/ / /_/ / /    ',
    ' \____/\____/_/ /_/_/ /_/\___/\___/\__/  /_/    \____/\____/_/     ',
    "\n"
    ].join("\n").light_yellow

clearLine = lambda { |loc| system "(tput cup #{loc} 0; tput el)"}
clearToEnd = lambda { |loc| system "(tput cup #{loc} 0; tput ed)"}
display = lambda { |loc, str| system "tput cup #{loc} 0"; print str}

gameArea = banner.split("\n").size
boardArea = gameArea + game.to_s.split("\n").size + 2
inputArea = boardArea + game.rows + 1
feedbackArea = inputArea + 1

puts banner
display.(gameArea, game.to_s)
puts "\nGame Start!".light_green
display.(boardArea, game.board.to_s)
display.(feedbackArea, feedback)

loop do
    display.(inputArea, "(connect4-p#{game.turn}) ")
    system "tput el"
	input = gets.chomp
    feedback.clear
    clearToEnd.(feedbackArea)

    # ✅ User wants to quit
    if input == 'q' or input == 'Q' or input == 'quit'
        clearToEnd.(feedbackArea)
        puts "Goodbye! 👋"
        exit

    # ✅ User wants to see a list of possible commands
    elsif input == 'h' or input == 'H' or input == 'help'
        feedback << [
            "Enter the number of the column you want to place a chip in.",
            "Other Commands:",
            # "   (p)rint:\tPrint the game board.",
            "   (l)oad:\tLoad a saved game from a file.",
            "   (s)ave:\tSave the current game.",
            "   (q)uit:\tQuit the game.",
            "\n"
        ].join("\n").yellow

	# ✅ User wants to load the game board from a file
	elsif input == 'l' or input == 'L' or input == 'load'
        clearLine.(inputArea)
        display.(inputArea, " Filename? ")
        filename = gets.chomp
        begin
            game = Engine.load(filename)
            clearToEnd.(gameArea)
            boardArea = gameArea + game.to_s.split("\n").size + 2
            inputArea = boardArea + game.rows + 1
            feedbackArea = inputArea + 1

            feedback << "File \"#{filename}\" loaded.".light_green
            display.(gameArea, game.to_s)
            puts "\nGame Start!".light_green
            display.(boardArea, game.board.to_s)
            display.(feedbackArea, feedback)

        rescue Errno::ENOENT => e
            feedback << e.message.light_red << ". File not loaded.".light_red
        end

	# ✅ User wants to save the game board to a file
	elsif input == 's' or input == 'S' or input == 'save'
        clearLine.(inputArea)
        display.(inputArea, " Filename? ")
        filename = gets.chomp
        game.save(filename)
        feedback << "File \"#{filename}\" saved.".light_green

    # ✅ User wants to place a chip
	elsif input =~ /\d+/ # input is a number and not any other command
        begin
        	game.placeChip(input.to_i)
            display.(boardArea, game.board.to_s)
            feedback << "Player #{game.turn} put a chip in column #{input}.".light_green
            game.advance_turn
        rescue Exception => e
            feedback << e.message.light_red
        end

    # ✅ User typed in garbage
    else
        feedback << "Unrecognized input. Consider using \'(h)elp.\'".light_red
    end

    display.(feedbackArea, feedback)

    # ✅ If a win or a full board was detected
    if game.checkWin == true or game.board.checkFull == true

        clearToEnd.(inputArea)
        if game.winner > 0
            display.(inputArea, "🎉 Player #{game.winner} wins by a #{game.winCase}! 🎉".light_green + "  Play again? (y/n) ")
        else
            display.(inputArea, "Game over, board is full!".light_yellow + " Play again? (y/n) ")
        end

        input = gets.chomp
        if input == 'y' or input == 'Y'
            game.reset
            display.(boardArea, game.board.to_s)
        else
            clearToEnd.(feedbackArea)
            puts "Goodbye! 👋"
            exit
        end
    end
end
