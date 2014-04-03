This is a terminal-based implementation of chess.  To play, navigate to the containing directory and execute "ruby chess.rb".  The game requires two human players; there is no AI at this time.

The game requires Ruby to be installed, and requires the "colorize" gem.  To install the latter, use "gem install colorize" in your terminal.

This game will not display properly in Windows terminals, due to lack of color code and Unicode support.

To make a move, input the square you are moving your piece from, press Enter, and input the square of the square you wish to move to.  Squares use chess notation format, with the first character being a letter for the column, and the second character being a number for the row (e.g. "e7" would be a front-rank pawn for Black).

You may save or load games in progress.  They will be saved to the "/saves" directory inside the containing folder.