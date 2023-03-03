#lang rocket
require rocket/stdlib

val length 14

def find-start(str, i)
  val unique-chars
    str.substring(i - length, i).string->list.list->set.set-count

  if (unique-chars = length)
    i
    find-start str (i + 1)

"day06.txt".file->string.find-start(length)
