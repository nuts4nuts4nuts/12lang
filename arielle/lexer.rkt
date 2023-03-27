#lang br
(require brag/support)

(define arielle-lexer
  (lexer-srcloc
    ["\n" (token 'NEWLINE lexeme)]
    [whitespace (token lexeme #:skip? #t)]
    [(:+ (:or alphabetic numeric "!"))
     (token 'STRING lexeme)]))

(provide arielle-lexer)
