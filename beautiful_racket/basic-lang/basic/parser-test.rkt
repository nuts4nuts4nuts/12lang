#lang br
(require "parser.rkt" brag/support rackunit)

(require basic/parser basic/tokenizer brag/support)

(define str #<<HERE
10 print "hello" : print "world"
20 goto 9 + 10 + 11
30 end
HERE
  )
(check-equal? (parse-to-datum (apply-tokenizer make-tokenizer str))
              '(b-program
                (b-line (b-line-num 10) (b-statement (b-print "print" (b-printable "hello"))) ":" (b-statement (b-print "print" (b-printable "world"))))
                "\n"
                (b-line (b-line-num 20) (b-statement (b-goto "goto" (b-expr (b-sum (b-number 9) "+" (b-number 10) "+" (b-number 11))))))
                "\n"
                (b-line (b-line-num 30) (b-statement (b-end "end")))))