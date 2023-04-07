#lang br/quicklang
(require markdown)

(define-macro (arielle-mod PARSE-TREE)
  #'(#%module-begin
     (display-xexpr (a-mod PARSE-TREE))))
(provide (rename-out [arielle-mod #%module-begin]))

(define-macro (a-mod PARSE-TREE)
  #'(parse-markdown PARSE-TREE))
(provide a-mod)

(define-macro (a-program RESULT-STR ...)
  #'(string-append RESULT-STR ...))
(provide a-program)

(define-macro (a-literal STR)
  #'STR)
(provide a-literal)

(define-macro (a-escaped-at)
  #'"@")
(provide a-escaped-at)

(module+ test
  (require rackunit)
  (check-equal?
   (a-mod (a-program
           (a-literal "abc")
           (a-literal " ")
           (a-literal "xyz")))
   '((p () "abc xyz")))
  (check-equal?
   (a-mod (a-program
           (a-literal "abc")
           (a-literal " ")
           (a-escaped-at)
           (a-literal " ")
           (a-literal "xyz")))
   '((p () "abc @ xyz"))))

(define-macro (jsonic-sexp SEXP-TOK)
  (with-pattern ([SEXP-DATUM (format-datum '~a #'SEXP-TOK)])
    #'(jsexpr->string SEXP-DATUM)))
(provide jsonic-sexp)

