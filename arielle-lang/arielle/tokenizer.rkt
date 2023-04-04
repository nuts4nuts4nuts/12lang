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
  (require rackunit)
  [check-equal?
   (list (token 'WORD "abc"))
   (srcloc-tokens->tokens (apply-tokenizer-maker make-tokenizer "abc"))]
  [check-equal?
   (list (token 'WORD "abc")
         (token 'WHITESPACE " ")
         (token 'AT "@")
         (token 'WORD "name")
         (token 'WHITESPACE " ")
         (token 'WORD "body")
         (token 'AT "@"))
   (srcloc-tokens->tokens (apply-tokenizer-maker make-tokenizer "abc @name body@"))]
  [check-equal?
   (list (token 'WORD "abc")
         (token 'WHITESPACE " ")
         (token 'ESCAPED-AT "\\@")
         (token 'WHITESPACE " ")
         (token 'WORD "stuff!"))
   (srcloc-tokens->tokens (apply-tokenizer-maker make-tokenizer "abc \\@ stuff!"))])
