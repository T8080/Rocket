#lang racket


(define (contract s)
  (syntax-case s (ldapp sdapp cdapp qcall ilist clist)
   [(ilist (x ...) y ...)
    (datum->syntax
     s
     (map contract (syntax-e #'(x ... y ...))))]
   [(clist x y ...)
    (datum->syntax
     s
     (map contract (syntax-e #'(x y ...))))]
   [(cdapp r (f a ...))
    (datum->syntax
     s
     `(,(contract #'f)
       ,(contract #'r)
       ,@(map contract (syntax-e #'(a ...)))))]
   [(cdapp r f)
    (datum->syntax
     s
     (list (contract #'f)
           (contract #'r)))]
   [(ldapp r (f a ...))
    (datum->syntax
     s
     `(,(contract #'f)
       ,(contract #'r)
       ,@(map contract (syntax-e #'(a ...)))))]
   [(ldapp r f)
    (datum->syntax
     s
     (list (contract #'f)
           (contract #'r)))]
   [(sdapp r (f a ...))
    (datum->syntax
     s
     `(,(contract #'f)
       ,(contract #'r)
       ,@(map contract (syntax-e #'(a ...)))))]
   [(sdapp r f)
    (datum->syntax
     s
     (list (contract #'f)
           (contract #'r)))]
   [(sdapp l f r)
    (datum->syntax
     s
     (list (contract #'f)
           (contract #'l)
           (contract #'r)))]
   [(qcall f a)
    (datum->syntax
     s
     (list (contract #'f)
           #''a))]
   [(ss ...)
    (datum->syntax
     s
     (map contract (syntax-e #'(ss ...))))]
   [_ s]))

(provide contract)
