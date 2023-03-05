#lang rocket
require rocket/stdlib

val cubes
  "day18.txt".file->lines
  .map; fun [l]
    l.string-split(",").map(string->number)
  .list->set

def unit-vectors; quote-multiple
  1  0  0
  -1 0  0
  0  1  0
  0 -1  0
  0  0  1
  0  0 -1

for*/sum [cube cubes, v unit-vectors]
  val x y z; cube
  val dx dy dz; v
  val neighbour; list(x + dx, y + dy, z + dz)
  if cubes.set-member?(neighbour) 0 1
