#lang rocket
require rocket/stdlib

define delta(x, d)
  x + d - 1 .modulo 3 + 1

define play(opp, outcome)
  delta opp (outcome - 2)

define outcome(opp, you)
  cond
    (you = delta(opp, 1)) 3
    (you = opp) 3
    else 0

define round(str)
  define opp; -
    str(0).char->integer + 1
    "A"(0).char->integer
  define you; -
    str(2).char->integer + 1
    "X"(0).char->integer
  define move
    play opp you

  outcome(opp, move) + move

"day02.txt".file->lines .map round .apply +
