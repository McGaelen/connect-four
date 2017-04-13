# CIS 343 Project 4 - Connect Four in Ruby
This is the classic game Connect Four, originally in C, rewritten in Ruby.  It's a game where 2 players drop tiles into a grid, and each player tries to connect four of their tiles in a row to win. This program is a text-based version of Connect Four run in the command line.  The user types in the number of the column they want to drop a tile into, and the grid/board is re-printed everytime a change is made. 

This version is object-oriented, and is much cleaner and less error prone than the C version.  The Ruby version also uses several different libraries and gems:
* optparse: Ruby's implementation of argument parsing.
* Marshal: Ruby's implementation of pickling objects, for loading and saving the game.
* colorize: a gem that makes it easy to change the color of a string that's displayed in the terminal.

### Features
This version has all the features of the C version, with extra enhancements. The user can customize width, height, number of connects, and ai, as well as load and save games. 

It can take the following command line arguments:

 Short| Long | Description
---|---|---
 (none) | **--help** | Display a help message
 **-w** | **--width=** | Width of the board
 **-h** | **--height=** | Height of the board
 **-s** | **--square=** | Set both the width and height
 **-c** | **--connect=** | How many connections needed to win
 **-l** | **--load=** | Load a game board from a file (overwrites other options)
 **-a** | **--ai=** | Determines if the AI should play as player 2
 
 While the game is running, it will accept the following commands:\*
 
  Command | Description
----------|----------
 **Any Number** | The column that the current player wants to drop a tile in.
 **(h)elp** | Show a help dialogue in-game.
 **(l)oad** | Load a game from a file (deletes exisiting game)
 **(s)ave** | Save the current game and it's parameters.
 **(q)uit** | Quits the game.
 
 \*Parenthesis around a letter indicate the short version of the command.

There is also a basic AI that was implemented to play against.  It's not a very robust AI, but it does more than just pick a random column.
