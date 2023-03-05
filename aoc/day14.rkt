#lang rocket
require rocket/stdlib

def parse-array(str)
  str.string-replace(",", " ").open-input-string.read

val groups
  "day13.txt"
  .file->string
  .string-split "\r\n\r\n"
  .flat-map; fun [str]
    str
    .string-split "\r\n"
    .map parse-array
  .append '[[[2]], [[6]]]

def in-order?(left, right); cond
  (left.number? .and right.number?
    if (left == right)
      'maybe
      left < right)
  (left.list? .and right.list?; cond
    (left.empty? .and right.empty?) 'maybe
    left.empty? true
    right.empty? false
    else
      val o? in-order?(left.first, right.first)
      if o?.boolean? o?; do
        in-order?(left.rest, right.rest))
  left.number?
  in-order?(left.list, right)
  right.number?
    in-order?(left, right.list)

val ordered groups.sort(in-order?)
val i ordered.index-of('[[2]]).inc
val j ordered.index-of('[[6]]).inc

i * j
