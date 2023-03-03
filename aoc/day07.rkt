#lang rocket
require rocket/stdlib

val lines "day07.txt".file->lines

def tree(ls, dir)
  if ls.empty?
    list ls dir
    match ls.car
      "$ cd .."
        list ls.rest dir
      pregexp("\\$ cd (.*)", list(_, name))
        val ls* subdir; tree ls.rest make-immutable-hash()
        tree ls* dir.hash-set(name, subdir)
      pregexp("(\\d+) (.*)", list(_, size, name))
        tree ls.rest dir.hash-set(name, size.string->number)
      _
        tree ls.cdr dir

val dir-sizes make-hash()

def dir-size(fs)
  for/sum [[k, v] in-hash(fs)]
    val s; if v.dict? v.dir-size() v
    when v.dict?
      dir-sizes.hash-set!(k, s)
    s

val x fs; lines.tree(make-immutable-hash())

val available-space; 70000000 - fs.dir-size
val required-freeing; 30000000 - available-space

dir-sizes.hash-values
.filter; fun [x]; x > required-freeing
.apply min
