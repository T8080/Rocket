#lang rocket
require rocket/stdlib

define parse-pair(str)
  str
  .string-split ",|-".regexp
  .map string->number

define contained(a, b, x, y)
  <= min(a, b) min(x, y) max(x, y) max(a, b)

define intersect(a, b, x, y)
  <= min(a, b) min(x, y) max(a, b)

define binarize(f); lambda [a, b, x, y]
  (f a b x y) .or (f x y a b)

"day04.txt"
.file->lines
.count; lambda [l]
  l.parse-pair .apply intersect.binarize
