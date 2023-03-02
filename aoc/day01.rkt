#lang rocket
require rocket/stdlib

define calories
  "day01.txt"
  .file->string
  .string-split "\r\n\r\n"
  .map; fun [group]
    group
    .string-split
    .map string->number
    .apply +

calories.apply(max)
calories.sort(>).take(3).apply(+)
