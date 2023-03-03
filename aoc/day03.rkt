#lang rocket
require rocket/stdlib

define priority(c); -
  c.char-downcase.char->integer
  "a".string-ref(0).char->integer
  if c.char-lower-case? -1 -27

define split(lst)
  define-values (l r)
    lst .split-at (lst.length / 2)
  list l r

define chunk(l, n)
  if l.empty? l
    l.take(n) .cons chunk(l.drop(n), n)

define common(lst)
  lst
  .map list->set
  .apply set-intersect
  .set-first

"day03.txt"
.file->lines
.map string->list
.chunk 3
.map common
.map priority
.apply +
