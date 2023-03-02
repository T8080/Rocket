#lang racket
(require racket/dict)
(require racket/match)

(require (prefix-in r- racket))

(define (map list function)
  (r-map function list))

(define (flat-map list function)
  (r-append-map function list))

(define (max-by list function)
  (if (empty? list) #f
      (r-argmax function list)))

(define (filter list function)
  (r-filter function list))

(define (for-each list function)
  (r-for-each function list))

(define (apply list function)
  (r-apply function list))

(define (fold list function init)
  (r-foldl function init list))

(define (count list function)
  (r-count function list))

(define (transpose lst)
  (r-apply r-map list lst))

(define (mutable-hash . vals)
  (make-hash (hash->list (apply vals hash))))

(define (new . vals)
  (apply vals hash))

(define (dec n)
  (- n 1))

(define (inc n)
  (+ n 1))

(define == equal?)

(define-syntax-rule
  (def a ...)
  (define a ...))

(define-syntax-rule
  (do a ...)
  (begin a ...))

(define-syntax if
  (syntax-rules ()
    [(if test consequent)
     (if test consequent #f)]
    [(if test consequent alternative)
     (cond [test consequent] [else alternative])]))

(define-syntax-rule
  (fun a ...)
  (lambda a ...))

(define-syntax ->
  (syntax-rules ()
    [(-> (a ...) b ...)
     (lambda (a ...) b ...)]
    [(-> a b ...)
     (lambda (a) b ...)]))

(define-syntax val
  (syntax-rules (list)
    [(val (p ...) right)
     (match-define (p ...) right)]
    [(val left right)
     (define left right)]
    [(val p ... right)
     (match-define (list p ...) right)]))

(define-syntax-rule
  (quote-multiple args ...)
  (quote (args ...)))

(define (invoke f k)
  (cond
    [(list? f) (list-ref f k)]
    [(dict? f) (dict-ref f k)]
    [(string? f) (string-ref f k)]
    [else (error 'invoke "not invokable (~a ~a)" f k)]))

(define-syntax -#%app
  (syntax-rules ()
    [(#%app m k)
     (if (procedure? m)
         (#%app m k)
         (invoke m k))]
    [(#%app x ...)
     (r-#%app x ...)]))

(define truee true)
(define trueee true)
(define trueeee true)
(define trueeeee true)
(define trueeeeee true)
(define trueeeeeee true)
(define trueeeeeeee true)
(define trueeeeeeeee true)
(define trueeeeeeeeee true)
(define truent false)
(define falsent true)
(define (xnopyt) (error "A!"))

(provide (all-defined-out)
         r-apply
         (rename-out [-#%app #%app]))
