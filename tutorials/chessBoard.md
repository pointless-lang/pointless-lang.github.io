---
layout: default
title: "Pointless: tutorials -- Rendering a Chess Board"
description: >-
  Rendering an HTML chess board from Forsyth-Edwards Notation in Pointless
---

### Tutorials:

## Rendering a Chess Board

<pre>- Avery N. Nortonsmith</pre>

<style>
  @font-face {
    font-family: "merida";
    src: url("merida.woff2") format("woff2");
  }

  .board {
    margin: 10px 0px;
    font-family: "merida";
    font-size: 50px;
    line-height: 1.0;
    border: 1px solid #ccc;
    display: inline-block;
    padding: 3px;
  }
</style>

-----

The [last tutorial](factorsVM.html) I wrote ended up being pretty long. This
time I'll try for something a little more "byte-sized".

In this tutorial I'll show you how to render an HTML chess board from [Forsyth-Edwards 
Notation](https://en.wikipedia.org/wiki/Forsyth–Edwards_Notation), a common
format for representing chess boards with text. Our end goal is to go from this:

`1Q6/5pk1/2p3p1/1p2N2p/1b5P/1bn5/2r3P1/2K5`

To this:

<pre class="board">
    
  ♟︎ 
 ♟︎ ♟︎
♟︎  ♟︎
    
♝   
 ♜ ♙
    
</pre>

And hopefully learn a bit of [Pointless](/) along the way.

-----

Forsyth-Edwards Notation (FEN) uses letters to represent chess pieces: `R` for rooks, `N` for knights, `B` for bishops, `Q` for queens, `K` for kings, and `P` for pawns. White pieces use uppercase characters, and black pieces use lowercase. Rows of the board are separated with slashes `/`. Empty squares within a row are represented with the digits 1-8, corresponding to the number of consecutive empty squares.

In a FEN string, the squares of a board are recorded from left-to-right, top-to-bottom. Here's the FEN encoding of the starting state for chess games `rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR`.

(A FEN string contains other game-state data -\- which side moves next, move number, etc -\- however, for this tutorial we'll only consider the board representation component)

Before we tackle rendering to HTML, we'll write a function `showBoard` which converts a FEN string to a more human-readable representation. The most basic version of this function splits the FEN string into rows (at the `/` character), and joins the rows with newlines:

<div class="sample">
  <pre class="highlight">
fen = "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR"

output =
  fen
  |> showBoard
  |> println

------------------------------------------------------------------------------

showBoard(fen) =
  fen
  |> split("/")
  |> join("\n")
</pre>
  <pre class="result">
$ ./bin/pointless render.ptls

rnbqkbnr
pppppppp
8
8
8
8
PPPPPPPP
RNBQKBNR
</pre>
</div>

This simple implementation gives us a halfway-decent board representation for the starting board position. However, things get messier when we apply it to more complex positions:

<div class="sample">
  <pre class="highlight">
fen = "1Q6/5pk1/2p3p1/1p2N2p/1b5P/1bn5/2r3P1/2K5"
</pre>
  <pre class="result">
$ ./bin/pointless render.ptls

1Q6
5pk1
2p3p1
1p2N2p
1b5P
1bn5
2r3P1
2K5
</pre>
</div>

To get something more readable we need to convert the digit-representation for blank squares into actual spaces. We'll write a function `expandRow` that will substitute the correct number of spaces for each spacing digit.

To start, `expandRow` splits a row string into a list of characters using `toList`. We use the `map` function to call `expandRow` on each row string in the FEN. The results of this are shown below:

<div class="sample">
  <pre class="highlight">
showBoard(fen) =
  fen
  |> split("/")
  |> map(expandRow)
  |> join("\n")

------------------------------------------------------------------------------

expandRow(row) =
  row
  |> toList
</pre>
  <pre class="result">
$ ./bin/pointless render.ptls

["1", "Q", "6"]
["5", "p", "k", "1"]
["2", "p", "3", "p", "1"]
["1", "p", "2", "N", "2", "p"]
["1", "b", "5", "P"]
["1", "b", "n", "5"]
["2", "r", "3", "P", "1"]
["2", "K", "5"]
</pre>
</div>

Next, we modify `expandRow` to call a new function, `expandChar` on each character in the row string. `expandChar` uses the dictionary `spaceDict` along with the function `getDefault` to replace spacing digits with spaces while leaving piece characters unaltered. The statement `getDefault(spaceDict, char, char)` gets the value for the key `char` in `spaceDict`, or returns the original `char` if `char` is not a key in `spaceDict`. `expandRow` now produces the following results:

<div class="sample">
  <pre class="highlight">
expandRow(row) =
  row
  |> toList
  |> map(expandChar)

expandChar(char) =
  getDefault(spaceDict, char, char)

spaceDict = {
  "8": "        ",
  "7": "       ",
  "6": "      ",
  "5": "     ",
  "4": "    ",
  "3": "   ",
  "2": "  ",
  "1": " ",
}
</pre>
  <pre class="result">
$ ./bin/pointless render.ptls

[" ", "Q", "      "]
["     ", "p", "k", " "]
["  ", "p", "   ", "p", " "]
[" ", "p", "  ", "N", "  ", "p"]
[" ", "b", "     ", "P"]
[" ", "b", "n", "     "]
["  ", "r", "   ", "P", " "]
["  ", "K", "     "]
</pre>
</div>

The last step for `expandRow` after converting the spacing digits in each row is to join the resulting characters back together. This is done with the `join` function:

<div class="sample">
  <pre class="highlight">
expandRow(row) =
  row
  |> toList
  |> map(expandChar)
  |> join("")
</pre>
</div>

Here's what our entire program and its output look like so far:

<div class="sample">
  <pre class="highlight">
fen = "1Q6/5pk1/2p3p1/1p2N2p/1b5P/1bn5/2r3P1/2K5"

output =
  fen
  |> showBoard
  |> println

------------------------------------------------------------------------------

showBoard(fen) =
  fen
  |> split("/")
  |> map(expandRow)
  |> join("\n")

------------------------------------------------------------------------------

expandRow(row) =
  row
  |> toList
  |> map(expandChar)
  |> join("")

expandChar(char) =
  getDefault(spaceDict, char, char)

spaceDict = {
  "8": "        ",
  "7": "       ",
  "6": "      ",
  "5": "     ",
  "4": "    ",
  "3": "   ",
  "2": "  ",
  "1": " ",
}
</pre>
  <pre class="result">
$ ./bin/pointless render.ptls

 Q      
     pk 
  p   p 
 p  N  p
 b     P
 bn     
  r   P 
  K 
</pre>
</div>

Running the program now gives us a board representation with proper spacing.

This board representation might be more readable than a FEN string, but it's still not ideal. A nicer representation would use symbols for pieces rather than letters, and would show the colors of board squares. While it's [possible](https://github.com/nickzuber/chs/) to use Unicode [symbols](https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode) and ANSI [color codes](https://en.wikipedia.org/wiki/ANSI_escape_code#Colors) to achieve these features in the terminal, using HTML and CSS to create board renderings will give us more stylistic control and make our renderings compatible with more devices.

To get started we'll add a new function `renderHTML` which will convert the board string output from `showBoard` into HTML. The HTML output is then passed to `println`:

<div class="sample">
  <pre class="highlight">
output =
  fen
  |> showBoard
  |> renderHTML
  |> println
</pre>
</div>

We want `renderHTML` to display each square with the correct square color. We'll do this by making a list of pairs of the form `(squareColor, pieceChar)` for each square in the input board string. This list is made by calling [zip](api/prelude/list.html#zip) with two arguments: an infinite list of alternating `Light` and `Dark` labels, and the list of characters in `boardStr`.

Since we iterate through board squares from left-to-right, top-to-bottom, the first square `a8` is `Light`.

Note that since each row is represented with an odd number of characters (8 squares and 1 newline, 9 total), the starting color of each row alternates as desired.

Our initial implementation of `renderHTML` and its output are shown below:

<div class="sample">
  <pre class="highlight">
colors =
  [Light, Dark] |> repeat |> concat

renderHTML(boardStr) =
  boardStr
  |> toList
  |> zip(colors)
</pre>
  <pre class="result">
$ ./bin/pointless render.ptls

[(Light, " "), (Dark, "Q"), (Light, " "), (Dark, " "), ...]
</pre>
</div>

To display our board, we'll use the [Chess Merida Unicode](http://mip.noekeon.org/HTMLTTChess/chess_merida_unicode.html) font, which has symbols for each chess piece on both light and dark squares. The characters for each symbol are stored in the `renderSyms` dictionary in the code below. Some of the characters won't render correctly until we display them in the merida font; until then they look like this: .

To render our `(squareColor, pieceChar)` pairs, we simply take the corresponding character from `renderSyms`. Note that newlines are mapped to newlines, regardless of their "color":

<div class="sample">
  <pre class="highlight">
renderHTML(boardStr) =
  boardStr
  |> toList
  |> zip(colors)
  |> map(getIndex(renderSyms))
  |> join("")

------------------------------------------------------------------------------

renderSyms = {
  (Dark,  "R" ): "",
  (Dark,  "r" ): "",
  (Dark,  "N" ): "",
  (Dark,  "n" ): "",
  (Dark,  "B" ): "",
  (Dark,  "b" ): "",
  (Dark,  "Q" ): "",
  (Dark,  "q" ): "",
  (Dark,  "K" ): "",
  (Dark,  "k" ): "",
  (Dark,  "P" ): "",
  (Dark,  "p" ): "",
  (Dark,  " " ): "",
  (Dark,  "\n"): "\n",
  (Light, "R" ): "♖",
  (Light, "r" ): "♜",
  (Light, "N" ): "♘",
  (Light, "n" ): "♞",
  (Light, "B" ): "♗",
  (Light, "b" ): "♝",
  (Light, "Q" ): "♕",
  (Light, "q" ): "♛",
  (Light, "K" ): "♔",
  (Light, "k" ): "♚",
  (Light, "P" ): "♙",
  (Light, "p" ): "♟︎",
  (Light, " " ): " ",
  (Light, "\n"): "\n",
}
</pre>
  <pre class="result">
$ ./bin/pointless render.ptls

    
  ♟︎ 
 ♟︎ ♟︎
♟︎  ♟︎
    
♝   
 ♜ ♙
    
</pre>
</div>

The results don't look like much in the terminal, where most of the characters won't render properly.

Time to write some CSS.

The `styles` variable below contains CSS to load our chess font and apply some styling to our board element. The function `formatTemplate` creates a string containing these styles, along with the symbol characters taken from `renderSyms` wrapped in an HTML `<pre>` tag:

<div class="sample">
  <pre class="highlight">
styles = """&lt;style&gt;
  @font-face {
    font-family: "merida";
    src: url("merida.woff2") format("woff2");
  }

  .board {
    font-family: "merida";
    font-size: 50px;
    border: 1px solid #ccc;
    display: inline-block;
    padding: 3px;
  }
&lt;/style&gt;
"""

formatTemplate(boardChars) =
  format("{}\n&lt;pre class='board'&gt;{}&lt;/pre&gt;", [styles, boardChars])
</pre>
</div>

We update `renderHTML` to call `formatTemplate` to complete our program, which now produces the following HTML output:

<div class="sample">
  <pre class="highlight">
renderHTML(boardStr) =
  boardStr
  |> toList
  |> zip(colors)
  |> map(getIndex(renderSyms))
  |> join("")
  |> formatTemplate
</pre>
  <pre class="result">
$ ./bin/pointless render.ptls

&lt;style&gt;
  @font-face {
    font-family: &quot;merida&quot;;
    src: url(&quot;merida.woff2&quot;) format(&quot;woff2&quot;);
  }

  .board {
    font-family: &quot;merida&quot;;
    font-size: 50px;
    border: 1px solid #ccc;
    display: inline-block;
    padding: 3px;
  }
&lt;/style&gt;

&lt;pre class='board'&gt;    
  ♟︎ 
 ♟︎ ♟︎
♟︎  ♟︎
    
♝   
 ♜ ♙
    &lt;/pre&gt;
</pre>
</div>

Now we just have to load our HTML output into the browser. We can run the script again and save the output to the file `render.html`:

`$ ./bin/pointless render.ptls > render.html`

And load `render.html` in a browser:

`$ firefox render.html`

Which should give us something like this:

<pre class="board">
    
  ♟︎ 
 ♟︎ ♟︎
♟︎  ♟︎
    
♝   
 ♜ ♙
    
</pre>

Nice! Much better than just displaying characters in the terminal.

At this point you might be thinking about ways to extend this sort of program to render an entire game. I had the same though when I wrote this tutorial, and I ended up building a site that lets you design and order posters of games using [Portable Game Notation](https://en.wikipedia.org/wiki/Portable_Game_Notation) (a text format for encoding entire games). You can [check it out here](https://checkmateposters.com)!

Here's the full code of our final program:

<div class="sample">
  <pre class="highlight">
fen = "1Q6/5pk1/2p3p1/1p2N2p/1b5P/1bn5/2r3P1/2K5"

output =
  fen
  |> showBoard
  |> renderHTML
  |> println

------------------------------------------------------------------------------

showBoard(fen) =
  fen
  |> split("/")
  |> map(expandRow)
  |> join("\n")

------------------------------------------------------------------------------

expandRow(row) =
  row
  |> toList
  |> map(expandChar)
  |> join("")

expandChar(char) =
  getDefault(spaceDict, char, char)

spaceDict = {
  "8": "        ",
  "7": "       ",
  "6": "      ",
  "5": "     ",
  "4": "    ",
  "3": "   ",
  "2": "  ",
  "1": " ",
}

------------------------------------------------------------------------------

colors =
  [Light, Dark] |> repeat |> concat

renderHTML(boardStr) =
  boardStr
  |> toList
  |> zip(colors)
  |> map(getIndex(renderSyms))
  |> join("")
  |> formatTemplate

------------------------------------------------------------------------------

renderSyms = {
  (Dark,  "R" ): "",
  (Dark,  "r" ): "",
  (Dark,  "N" ): "",
  (Dark,  "n" ): "",
  (Dark,  "B" ): "",
  (Dark,  "b" ): "",
  (Dark,  "Q" ): "",
  (Dark,  "q" ): "",
  (Dark,  "K" ): "",
  (Dark,  "k" ): "",
  (Dark,  "P" ): "",
  (Dark,  "p" ): "",
  (Dark,  " " ): "",
  (Dark,  "\n"): "\n",
  (Light, "R" ): "♖",
  (Light, "r" ): "♜",
  (Light, "N" ): "♘",
  (Light, "n" ): "♞",
  (Light, "B" ): "♗",
  (Light, "b" ): "♝",
  (Light, "Q" ): "♕",
  (Light, "q" ): "♛",
  (Light, "K" ): "♔",
  (Light, "k" ): "♚",
  (Light, "P" ): "♙",
  (Light, "p" ): "♟︎",
  (Light, " " ): " ",
  (Light, "\n"): "\n",
}

------------------------------------------------------------------------------

styles = """&lt;style&gt;
  @font-face {
    font-family: "merida";
    src: url("merida.woff2") format("woff2");
  }

  .board {
    font-family: "merida";
    font-size: 50px;
    border: 1px solid #ccc;
    display: inline-block;
    padding: 3px;
  }
&lt;/style&gt;
"""

formatTemplate(boardChars) =
  format("{}\n&lt;pre class='board'&gt;{}&lt;/pre&gt;", [styles, boardChars])
</pre>
</div>
