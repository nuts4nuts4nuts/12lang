#lang br
(require brag/support)
(provide arielle-lexer)

(define arielle-lexer
  (lexer-srcloc
   ["@(" (token 'OPEN-AMAL lexeme)]
   ["\\@(" (token 'ESCAPED-OPEN-AMAL lexeme)]
   [":" (token 'COLON lexeme)]
   ["\\:" (token 'ESCAPED-COLON lexeme)]   
   [")" (token 'CLOSE-PAREN lexeme)]
   [whitespace (token 'WHITESPACE lexeme)]
   [(:or (:seq (:~ (:or wh "@")) (:+ (:~ wh)))
         (:seq "@" (:~ (:or wh "(")) (:+ (:~ wh))))
    (token 'WORD lexeme)]))

(define wh
  (:or whitespace ":" ")"))
