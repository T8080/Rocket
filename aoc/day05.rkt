#lang rocket
require rocket/stdlib

define height 8
define lines; "day05.txt".file->lines

define stacks
  lines
  .take height
  .map string->list
  .transpose
  .filter; [l] -> l.last.char-alphabetic?
  .map; [l] -> l.filter(char-alphabetic?)

define moves
  lines
  .drop; height + 2
  .map; lambda [l]
    regexp-match* "\\d+".pregexp l
    .map string->number

define move(stacks, n, from, to)
  define x stacks.list-ref(from.dec).take(n)
  stacks
  .list-set from.dec stacks.list-ref(from.dec).drop(n)
  .list-set to.dec x.append(stacks.list-ref(to.dec))

moves
.fold
  lambda [m, s]; r-apply move s m
  stacks
.map first
.apply string
