#lang rocket
require rocket/stdlib

def parse-line(str)
  regexp-match*("-?\\d+".pregexp, str).map(string->number)

def dist(sx, sy, ex, ey)
  (ex - sx).abs + (ey - sy).abs

val target-y 2000000
val xy-max 4000000
val sensors; "day15.txt".file->lines.map(parse-line)
val beacon-positions; sensors.map([s] -> s.drop(2)).list->set

val positions mutable-set()
for [sensor sensors]
  val sx sy ex ey sensor
  val d dist(sx, sy, ex, ey)
  for [x in-range(-10000000, 10000000)]
    if (dist(sx, sy, x, target-y) <= d)
      if not(set-member?(beacon-positions, list(x, target-y)))
        positions.set-add!(x)

positions.set-count

let/cc let-me-OUT
  def it?(x, y)
    and
      <= 0 x xy-max
      <= 0 y xy-max
      for/and [sensor sensors]
        val sx sy ex ey sensor
        val d dist(sx, sy, ex, ey)
        dist(sx, sy, x, y) > d
    .if
      let-me-OUT(x * 4000000 + y)

  for [sensor sensors]
    val x y ex ey; sensor
    val d; dist(x, y, ex, ey)
    val o; d.inc
    for [i in-range(o)]
      or
        it?(x + (o - i), y - i)
        it?(x - i, y - (o - i))
        it?(x - (o - i), y + i)
        it?(x + i, y + (o - i))

  xnopyt()
