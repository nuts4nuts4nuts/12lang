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
                                          (a-word "abc")
                                          (a-whitespace " ")
                                          (a-word "xyz"))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "xyz abc\nwelcome!")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-word "xyz")
                                          (a-whitespace " ")
                                          (a-word "abc")
                                          (a-whitespace "\n")
                                          (a-word "welcome!"))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@()")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-word "xyz")
                                          (a-whitespace " ")
                                          (a-word "abc")
                                          (a-whitespace "\n")
                                          (a-word "welcome!")))))
