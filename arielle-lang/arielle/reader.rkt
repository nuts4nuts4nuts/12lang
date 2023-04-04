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
   (syntax->datum (read-syntax "" (open-input-string "@name body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           (a-at)
                                           (a-expr-name "name")
                                           (a-whitespace " ")
                                           (a-expr-body (a-program (a-word "body")))
                                           (a-at)))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@  name body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           (a-at)
                                           (a-whitespace " ")
                                           (a-whitespace " ")
                                           (a-expr-name "name")
                                           (a-whitespace " ")
                                           (a-expr-body (a-program (a-word "body")))
                                           (a-at)))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name arg:val body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           (a-at)
                                           (a-expr-name "name")
                                           (a-whitespace " ")
                                           (a-expr-args (a-arg-key "arg")
                                                        (a-arg-value "val"))
                                           (a-whitespace " ")
                                           (a-expr-body (a-program (a-word "body")))
                                           (a-at)))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name arg:val arg2:val2 body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           (a-at)
                                           (a-expr-name "name")
                                           (a-whitespace " ")
                                           (a-expr-args (a-arg-key "arg")
                                                        (a-arg-value "val")
                                                        (a-arg-key "arg2")
                                                        (a-arg-value "val2"))
                                           (a-whitespace " ")
                                           (a-expr-body (a-program (a-word "body")))
                                           (a-at)))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "Regular words @name arg:val arg2:val2 body@\nNew line!")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-word "Regular")
                                          (a-whitespace " ")
                                          (a-word "words")
                                          (a-whitespace " ")
                                          (a-expr
                                           (a-at)
                                           (a-expr-name "name")
                                           (a-whitespace " ")
                                           (a-expr-args
                                            (a-arg-key "arg")
                                            (a-arg-value "val")
                                            (a-arg-key "arg2")
                                            (a-arg-value "val2"))
                                           (a-whitespace " ")
                                           (a-expr-body (a-program (a-word "body")))
                                           (a-at))
                                          (a-whitespace "\n")
                                          (a-word "New")
                                          (a-whitespace " ")
                                          (a-word "line!")))))
