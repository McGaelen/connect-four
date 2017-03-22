#!/usr/bin/env ruby
#
# CIS 343 Connect Four in Ruby - main program file
# Gaelen McIntee
# ?/?/???
#
# Connect Four: Place 4 tiles in a row vertically, horizontally, or diagonally to win.
#
# Notes:
# => May need to install the 'colorize' gem for it to run ("gem install colorize")
# => To see the ascii art correctly, terminal should be at least 67 cols wide
# => Pickling uses Ruby's Marshal library
# => Option parsing uses Ruby's OptionParser class (in 'optparse')
# => Some feedback statements print emoji, so some weird chars may print out if
#    the terminal doesn't support displaying them
#
# Issues:
# => cmd line args are not required to have a value
##

# TODO:
#❌   Fix cmd line issue
#❌   Comment the shit out of this thing
#❌   add AI
#❌   Test for really big boards


# require 'pry'  # Debugging
require 'colorize' # Allow for changing color of a string.
require_relative 'Engine'
require_relative 'Arguments'


feedback = "" # Used to store any feedback given to the user.

# Create a new Arguments instance and parse through ARGV.
# The feedback var is set to the error message, if any.
# ARGV is not modified.
args = Arguments.new
begin
    args.parse(ARGV)
rescue Exception => e
    feedback << e.message.light_red << ". Consider using '--help'. ".light_red << "All following options ignored.\n".light_red
end

exit if ARGV.include? "--help" # Leave if we're only printing help dialouge
ARGV.clear # Clear ARGV to avoid reading stray input

# Create a new gameboard with the command line args.
# If any other arguments are given with "-l", the load file will override them.
game = Engine.new(args.rows, args.cols, args.connect, 1, args.ai)
if !(args.load.empty?)
    begin
        game = Engine.load(args.load)
        feedback << "File \"#{args.load}\" loaded.\n".light_green
    rescue Errno::ENOENT => e
        feedback << e.message.light_red << ". Using default settings.\n".light_red
    end
end


system "clear" # So we don't mess up the terminal's display

# Ascii art generated at http://patorjk.com/software/taag/ using the "Slant" font
banner = [
    '    ______                            __     ______                ',
    '   / ____/___  ____  ____  ___  _____/ /_   / ____/___  __  _______',
    '  / /   / __ \/ __ \/ __ \/ _ \/ ___/ __/  / /_  / __ \/ / / / ___/',
    ' / /___/ /_/ / / / / / / /  __/ /__/ /_   / __/ / /_/ / /_/ / /    ',
    ' \____/\____/_/ /_/_/ /_/\___/\___/\__/  /_/    \____/\____/_/     ',
    "\n"
].join("\n").light_yellow

# These automate the process of positioning the cursor to the give location
# and performing their given function, using the 'tput' command in the terminal.
# clearLine clears from the cursor position given by 'loc' to the end of the line.
clearLine = lambda { |loc| system "(tput cup #{loc} 0; tput el)" }
# clearToEnd clears from the cursor position given by 'loc' to the end of the terminal.
clearToEnd = lambda { |loc| system "(tput cup #{loc} 0; tput ed)" }
# display prints the string 'str' from the start point 'loc',
# overwriting anything in the way.
display = lambda { |loc, str| system "tput cup #{loc} 0"; print str }

# Each of these mark the starting location of section of the game to print
# (the locations where the cursor should be positioned)
# These are passed into the lambda functions as 'loc'
gameArea = banner.split("\n").size
boardArea = gameArea + game.to_s.split("\n").size + 2
inputArea = boardArea + game.rows + 1
feedbackArea = inputArea + 1

puts banner
display.(gameArea, game.to_s)
puts "\nGame Start!".light_green
display.(boardArea, game.board.to_s)
display.(feedbackArea, feedback)

# Main program loop.  Every loop performs these steps:
# 1. display the prompt and get user input.
# 2. process the command given by the user, if valid.
# 3. display the feedback from the command that was processed.
# 4. Check for a winner.
#      - If there's a winner, offer to restart the game, or exit.
loop do
    # 1. display the prompt and get user input.
    display.(inputArea, "(connect4-p#{game.turn}) ") # prompt
    system "tput el"  # clears out previous input
	input = gets.chomp
    feedback.clear  # clears the feedback string itself
    clearToEnd.(feedbackArea)  # clears the area displaying the feedback string

    # 2. process the command given by the user, if valid.
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
		# Get the filename from the user
        clearLine.(inputArea)
        display.(inputArea, " Filename? ")
        filename = gets.chomp
		# Try to load the file, set the new display areas based on the incoming game,
		# and display all of it.
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
		# If loading fails, print the error message in the feedback string.
        rescue Errno::ENOENT => e
            feedback << e.message.light_red << ". File not loaded.".light_red
        end

	# ✅ User wants to save the game board to a file
	elsif input == 's' or input == 'S' or input == 'save'
		# Get the filename, and save the current game to a file.  Print a success message.
        clearLine.(inputArea)
        display.(inputArea, " Filename? ")
        filename = gets.chomp
        game.save(filename)
        feedback << "File \"#{filename}\" saved.".light_green

    # ✅ User wants to place a chip
	elsif input =~ /\d+/ # input is a number and not any other command
		# try to place a chip in the given column
        begin
        	game.placeChip(input.to_i)  # This can throw an exception
            display.(boardArea, game.board.to_s)
            feedback << "Player #{game.turn} put a chip in column #{input}.".light_green
            game.advance_turn
		# if placeChip fails, print the reason in the feedback.
        rescue Exception => e
            feedback << e.message.light_red
        end

    # ✅ User typed in garbage
    else
        feedback << "Unrecognized input. Consider using \'(h)elp.\'".light_red
    end

    # 3. display the feedback from the command that was processed.
    display.(feedbackArea, feedback)

    # 4. Check for a win.
    # ✅ If a win or a full board was detected
    if game.checkWin == true or game.board.checkFull == true
        # Display the result of the game in the inputArea, and offer to restart
        clearToEnd.(inputArea)
        if game.winner > 0
            display.(inputArea, "🎉 Player #{game.winner} wins by a #{game.winCase}! 🎉".light_green + "\nPlay again? (y/n) ")
        else
            display.(inputArea, "Game over, board is full!".light_yellow + "\nPlay again? (y/n) ")
        end

        # Restart if the user typed 'y'. If they typed anything else, exit.
        input = gets.chomp
        if input == 'y' or input == 'Y'
			clearToEnd.(feedbackArea)
            game.reset
            display.(boardArea, game.board.to_s)
        else
            clearToEnd.(feedbackArea)
            puts "Goodbye! 👋"
            exit
        end
    end
end
