#lang br
(require brag/support)
(provide arielle-lexer)

(define arielle-lexer
  (lexer-srcloc
   ["@" (token 'AT lexeme)]
   ["\\@" (token 'ESCAPED-AT lexeme)]
   [":" (token 'COLON lexeme)]
   [whitespace (token 'WHITESPACE lexeme)]
   [(:+ (:~ (:or "@" ":" whitespace)))  (token 'WORD lexeme)]))
