#lang rocket
require rocket/stdlib

define input "day09.txt".file->lines

define vectors; hash
  "R";0, '[1, 0]
  "L";0, '[-1, 0]
  "U";0, '[0, 1]
  "D";0, '[0, -1]

define sign(n); cond
  (n > 0) 1
  (n < 0) -1
  else 0

define main(parts, lines)
  val visited; list(0, 0).mutable-set

  define step(hx, hy, tx, ty, dir)
    val tdx; hx - tx
    val tdy; hy - ty

    cond
      (tdx.abs + tdy.abs > 2)
        set! tx; tx + tdx.sign
        set! ty; ty + tdy.sign
      (tdx.abs > 1)
        set! tx; tx + tdx.sign
      (tdy.abs > 1)
        set! ty; ty + tdy.sign

    list(hx, hy, tx, ty)

  for* [line lines, s line.string-split()(1).string->number]

    for [i range(0, 9)]
      val is; i * 2
      val hx hy tx ty _ ...; parts.drop(is)
      when (i = 0)
        val dx dy; line(0).vectors
        set! hx; hx + dx
        set! hy; hy + dx

      val hx* hy* tx* ty* _ ...; step(hx, hy, tx, ty, line(0))

      parts .set!
        parts
        .list-set(is, hx*)
        .list-set(is + 1, hy*)
        .list-set(is + 2, tx*)
        .list-set(is + 3, ty*)

    visited.set-add!(list(parts(18), parts(19)))

  set-count(visited)

main(make-list(20, 0), input)
