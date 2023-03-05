#lang rocket
require rocket/stdlib
require data/queue

val grid
  "day12.txt"
  .file->lines
  .list->vector

val h grid.vector-length
val w grid(0).string-length

val start
  for*/first [y in-range(h), x in-range(w), #when, grid(y)(x) .eq? "E"(0)]
    list(x, y)

val q make-queue()
val v mutable-set()

q.enqueue!(start.list)
v.set-add!(start)

def elevation(c)
  cond
    (c == "S"0) elevation("a"0)
    (c == "E"0) elevation("z"0)
    else c.char->integer

def find()
  if q.queue-empty? false; do
    val node q.dequeue!
    val x y node.first
    val n grid(y)(x)
    if (grid(y)(x) == "a"0) node; do
      for [yy list(y - 1, y + 1, y, y), xx list(x, x, x - 1, x + 1)]
        and
          < -1 xx w
          < -1 yy h
          (grid(y)(x).elevation - grid(yy)(xx).elevation) <= 1
          not; v .set-member? list(xx, yy)
        .when
          q.enqueue!(list(xx, yy).cons(node))
          v.set-add!(list(xx, yy))
      find()

find().length - 1
