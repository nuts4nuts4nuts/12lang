#lang br/quicklang
(require markdown)

(define-macro (arielle-mod PARSE-TREE)
  #'(#%module-begin
     (define result-string PARSE-TREE)
     (define validated-jsexpr (string->jsexpr result-string))
     (display result-string)))
(provide (rename-out [arielle-mod #%module-begin]))

(define-macro (jsonic-char CHAR-TOK)
  #'CHAR-TOK)
(provide jsonic-char)

(define-macro (jsonic-program SEXP-OR-JSON-CHAR ...)
  #'(string-trim (string-append SEXP-OR-JSON-CHAR ...)))
(provide jsonic-program)

(define-macro (jsonic-sexp SEXP-TOK)
  (with-pattern ([SEXP-DATUM (format-datum '~a #'SEXP-TOK)])
    #'(jsexpr->string SEXP-DATUM)))
(provide jsonic-sexp)

