#lang racket

(require "donutspace.rkt"
         "expander.rkt"
         syntax/strip-context
         syntax/stx
         brag/support
         br-parser-tools/lex
         (prefix-in : br-parser-tools/lex-sre))

(define-lex-abbrev symbol-symbol
  (:or symbolic "-" "*" "!" "?" "/" "~" ">" "_"
       "_"))

(define-lex-abbrev operator
  (:+ symbol-symbol))

(define-lex-abbrev space-symbol
  (:+ (:- (:or alphabetic symbol-symbol)
          (:or ";" "'" "," "$"))))

(define-lex-abbrev symbol
  (:- (:: space-symbol
          (:* (:+ space-symbol numeric)))))

(define-lex-abbrev linebreak
  (:: (:? "\r") "\n"))

(define-lex-abbrev string
  (:: "\""
      (:* (:or (:~ "\"" "\\")
               (:or "\\\"" "\\\\" "\\n" "\\r")))
      "\""))

(define (normalize-string str)
  (define lexeme (string-replace (string-replace (string-replace str "\\r" "\r") "\\n" "\n") "\\\\" "\\"))
  (substring lexeme 1 (- (string-length lexeme) 1)))

(define (indent-level str)
  (for/first ([i (in-range (string-length str))]
              #:when (eq? #\newline (string-ref str (- (string-length str) i 1))))
    i))

(define lex
  (lexer-src-pos
   [(eof) 'EOF]
   ["(" 'OP]
   [")" 'CP]
   ["[" 'OB]
   ["]" 'CB]
   [">>" '>>]
   ["<<" '<<]
   ["," 'C]
   [(:or ";" ":") 'SC]
   ["'" 'Q]
   ["\"" 'QQ]
   ["$" 'UQ]
   ;; ["_" 'US]
   ["..." (token 'SYM (string->symbol "..."))]
   ["." 'DOT]
   [(:: (:+ linebreak) (:* " ")) (indent-level lexeme)]
   [(:+ " ") 'S]
   [(:: (:? "-") (:+ numeric)) (token 'NUM (string->number lexeme))]
   [(:+ symbol-symbol) (token 'OPSYM (string->symbol lexeme))]
   [(:: "#" symbol) (token 'KW (string->keyword (substring lexeme 1)))]
   [symbol (token 'SYM (string->symbol lexeme))]
   [string (token 'STR (normalize-string lexeme))]))

(define indent 0)
(define prev-indent 0)
(define token-queue '())

(define (ilex port)
  (if (not (empty? token-queue))
      (let ((t (first token-queue)))
        (set! token-queue (rest token-queue))
        t)
      (let* ((tkn (lex port))
             (t (position-token-token tkn)))
        (if (number? t)
            (cond
              [(> t prev-indent)
               (set! token-queue '(>>))
               (set! prev-indent t)
               'NL]
              [(< t prev-indent)
               (set! token-queue (flatten (make-list (quotient (- prev-indent t) 2) '(<< NL))))
               (set! prev-indent t)
               'NL]
              [else
               'NL])
            tkn))))

(define (blex in)
  (define content (port->string in))
  (define content*
    ;; (regexp-replace* #px" ([^\\w\\s\\.;,\\(\\)]+)(\\s)" content " .\\1\\2")
    (regexp-replace* #px" ([^\\w\\s\\.;,\\(\\)]+) " content " .\\1 "))
  (define port (open-input-string content*))
  (define lexer-func (lambda () (ilex port)))
  lexer-func)

(define (plex in)
  (define ret (ilex in))
  (println ret)
  ret)

(define (read-space-syntax src in)
  (define stx-raw (parse src (blex in)))
  (define stx (contract (replace-context #'hmmm stx-raw)))
  (define body (stx-cdr stx))
  (define out
    (datum->syntax
     stx
     `(module test racket/base
        ,@body)))
  (println (syntax->datum stx-raw))
  (println (syntax->datum stx))
  out)


(define (read-space in)
  '(xnopyt))

(provide (rename-out
          [read-space-syntax read-syntax]
          [read-space read]))
