#lang rocket
require rocket/stdlib

val instructions
  "day10.txt".file->lines
  .map; fun [line]
    match line
      "noop"
        0
      pregexp("addx (.+)", list(_, n))
        n.string->number

val s; 6 * 40
val states; make-vector(s + 100)
val instr; 0
val timer; 1
val x; 1

for [i in-range(0, s + 100)]
  states.vector-set!(i, x)
  val ii; i - 1 .remainder 40

  display; if (<= ii.dec x ii.inc) "#" " "
  when (i .remainder 40 = 0)
    newline()

  set! timer; timer - 1
  when (timer = 0)
    set! x; x + instr
    when instructions.empty?.not
      set! instr; instructions.first
      set! instructions instructions.rest
    set! timer; if (instr = 0) 1 2

for/sum [i '[20, 60, 100, 140, 180, 220]]
  states;i * i
