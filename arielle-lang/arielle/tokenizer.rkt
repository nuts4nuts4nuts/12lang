#lang br
(require "lexer.rkt" brag/support)
(provide make-tokenizer)

(define (make-tokenizer port [path #f])
  (port-count-lines! port)
  (lexer-file-path path)
  (define (next-token) (arielle-lexer port))
  next-token)

(module+ test
  (define (srcloc-tokens->tokens srcloc-tokens)
    (map (lambda (srcloc-token) (srcloc-token-token srcloc-token))
         srcloc-tokens))
  (define (str->CHARs str)
    (map (lambda (char) (token 'CHAR (string char)))
         (string->list str)))
  (require rackunit)
  [check-equal?
   (str->CHARs "abc")
   (srcloc-tokens->tokens (apply-tokenizer-maker make-tokenizer "abc"))]
  [check-equal?
   (append (str->CHARs "abc ")
           (list (token 'EXPR "name body")))
   (srcloc-tokens->tokens (apply-tokenizer-maker make-tokenizer "abc @(name body)@"))])
