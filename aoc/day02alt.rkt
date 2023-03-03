#lang rocket
require rocket/stdlib

define score(str); case str
  ["A X"] 3
  ["B X"] 1
  ["C X"] 2
  ["A Y"] 4
  ["B Y"] 5
  ["C Y"] 6
  ["A Z"] 8
  ["B Z"] 9
  ["C Z"] 7

"day02.txt".file->lines .map score .apply +
