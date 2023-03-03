#lang rocket
require rocket/stdlib

define grid
  "day08.txt".file->lines
  .map; fun [l]
    l.string->list
    .map; fun [c]; c.char->integer - 48
    .list->vector
  .list->vector

define size grid.vector-length

define visible-dir?(t, x, y, dx, dy)
  or
    x < 0, x > size.dec
    y < 0, y > size.dec
    and
      grid;y;x < t
      visible-dir?(t, x + dx, y + dy, dx, dy)

define visible?(x, y)
  for/or [dx '[1, -1, 0, 0], dy '[0, 0, 1, -1]]
    visible-dir?(grid;y;x, x + dx, y + dy, dx, dy)

define scenic-score(x, y)
  for/product [dx '[1, -1, 0, 0], dy '[0, 0, 1, -1]]
    view-distance(grid;y;x, x + dx, y + dy, dx, dy)

define view-distance(t, x, y, dx, dy)
  if
    or
      x < 0, x > size.dec
      y < 0, y > size.dec
    0
    if (grid;y;x >= t) 1
      view-distance(t, x + dx, y + dy, dx, dy) + 1

for*/list [x size.range, y size.range]
  scenic-score(x, y)
.apply max

