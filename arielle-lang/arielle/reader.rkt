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
                                          (a-literal "abc")
                                          (a-literal " ")
                                          (a-literal "xyz"))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "xyz abc\nwelcome!")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-literal "xyz")
                                          (a-literal " ")
                                          (a-literal "abc")
                                          (a-literal "\n")
                                          (a-literal "welcome!"))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           "name"
                                           ((a-literal "body"))))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@  name body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           "name"
                                           ((a-literal "body"))))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name arg:val body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           "name"
                                           ("arg"
                                            "val")
                                           ((a-literal "body"))))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name arg:val arg2:val2 body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           "name"
                                           ("arg"
                                            "val"
                                            "arg2"
                                            "val2")
                                           ((a-literal "body"))))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "Regular words @name arg:val arg2:val2 body more@\nNew line!")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-literal "Regular")
                                          (a-literal " ")
                                          (a-literal "words")
                                          (a-literal " ")
                                          (a-expr
                                           "name"
                                           ("arg"
                                            "val"
                                            "arg2"
                                            "val2")
                                           ((a-literal "body")
                                            (a-literal " ")
                                            (a-literal "more")))
                                          (a-literal "\n")
                                          (a-literal "New")
                                          (a-literal " ")
                                          (a-literal "line!"))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name arg:val arg2:val2 words @nested body@ @")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           "name"
                                           ("arg"
                                            "val"
                                            "arg2"
                                            "val2")
                                           ((a-literal "words")
                                            (a-literal " ")
                                            (a-expr
                                             "nested"
                                             ((a-literal "body")))))))))
