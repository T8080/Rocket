#lang rocket
require rocket/stdlib

def Monkey(str)
  val lines str.string-split("\r\n")
  mutable-hash
    'items
    lines(1).substring(18).string-split(", ").map(string->number)
    'operation
    lines(2).substring(19).string-split
    'test
    lines(3).substring(21).string->number
    'if-true
    lines(4).substring(29).string->number
    'if-false
    lines(5).substring(30).string->number

def eval-operation(operation, old)
  def eval-datum(datum)
    if (datum == "old")
      old
      datum.string->number
  def eval-op(op)
    if (op == "+")
      +
      *
  eval-op(operation'1)(operation'0.eval-datum, operation'2.eval-datum)

val monkeys
  "day11.txt"
  .file->string
  .string-split "\r\n\r\n"
  .map Monkey

val test-lcm monkeys.map(m -> m'test).apply(lcm)

val inspection-counts mutable-hash()
for [i monkeys.length]
  inspection-counts.hash-set!(i, 0)

def update(monkeys, i)
  val monkey monkeys(i)

  val items
    monkey'items
    .map; [x] -> monkey'operation.eval-operation(x).modulo(test-lcm)

  def test?(item)
    item .remainder monkey'test == 0

  monkeys(i).hash-set!('items, '[])

  def throw(item, mi)
    val items monkeys(mi)'items
    monkeys(mi).hash-set!('items, item .cons items)

  for [item items]
    inspection-counts.hash-update!(i, inc)
    throw(item, monkey(if item.test? 'if-true 'if-false))

for* [i range(10000), m range(monkeys.length)]
  update monkeys m

inspection-counts
inspection-counts.hash-values.sort(>).take(2).apply(*)
