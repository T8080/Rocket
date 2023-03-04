#lang rocket
require rocket/stdlib

val char-values; hash
  "2"(0), 2
  "1"(0), 1
  "0"(0), 0
  "-"(0), -1
  "="(0), -2

val value-chars; for/hash [[k, v] char-values]; values v k

def snafu->number(snafu)
  val l snafu.string-length
  for/sum [i l.range]
    5 .expt i * snafu(l - i - 1).char-values

def number->snafu(n)
  if (n == 0) '[]; do
    val r n.remainder(5)
    val q n.quotient(5)
    if (r > 2)
      value-chars(r - 5) .cons number->snafu(q + 1)
      value-chars(r) .cons number->snafu(q)

"day25.txt"
.file->lines
.map snafu->number
.apply +
.number->snafu
.reverse
.list->string
