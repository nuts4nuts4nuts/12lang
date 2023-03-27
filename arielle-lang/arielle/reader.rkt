#lang br/quicklang
(require "parser.rkt" "tokenizer.rkt")
(provide read-syntax)

(define (read-syntax path port)
  (define parse-tree (parse path (make-tokenizer port path)))
  (strip-bindings
   #`(module arielle-mod arielle/expander
       #,parse-tree)))

(module+ test
  (require rackunit)
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "abc xyz")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-paragraph
                                           (a-expr "abc")
                                           (a-expr "xyz")))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "xyz abc\nwelcome!")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-paragraph
                                           (a-expr "xyz")
                                           (a-expr "abc"))
                                          (a-paragraph
                                           (a-expr "welcome!"))))))
