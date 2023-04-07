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
                                           (a-expr-name "name")
                                           (a-expr-body (a-literal "body"))))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@  name body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           (a-expr-name "name")
                                           (a-expr-body (a-literal "body"))))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name arg:val body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           (a-expr-name "name")
                                           (a-expr-args "arg"
                                                        "val")
                                           (a-expr-body (a-literal "body"))))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name arg:val arg2:val2 body@")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           (a-expr-name "name")
                                           (a-expr-args "arg"
                                                        "val"
                                                        "arg2"
                                                        "val2")
                                           (a-expr-body (a-literal "body"))))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "Regular words @name arg:val arg2:val2 body@\nNew line!")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-literal "Regular")
                                          (a-literal " ")
                                          (a-literal "words")
                                          (a-literal " ")
                                          (a-expr
                                           (a-expr-name "name")
                                           (a-expr-args "arg"
                                                        "val"
                                                        "arg2"
                                                        "val2")
                                           (a-expr-body (a-literal "body")))
                                          (a-literal "\n")
                                          (a-literal "New")
                                          (a-literal " ")
                                          (a-literal "line!"))))
  (check-equal?
   (syntax->datum (read-syntax "" (open-input-string "@name arg:val arg2:val2 words @nested body@ @")))
   '(module arielle-mod arielle/expander (a-program
                                          (a-expr
                                           (a-expr-name "name")
                                           (a-expr-args "arg"
                                                        "val"
                                                        "arg2"
                                                        "val2")
                                           (a-expr-body
                                            (a-literal "words")
                                            (a-literal " ")
                                            (a-expr
                                             (a-expr-name "nested")
                                             (a-expr-body (a-literal "body")))))))))
