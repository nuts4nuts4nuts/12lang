#lang br
(require brag/support)
(provide arielle-lexer)

(define arielle-lexer
  (lexer-srcloc
   [(from/to "@(" ")@") (token 'EXPR (trim-ends "@(" lexeme ")@"))]
   [any-char (token 'CHAR lexeme)]))
