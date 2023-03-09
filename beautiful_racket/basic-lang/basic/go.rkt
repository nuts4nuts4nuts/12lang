#lang br
(require "struct.rkt" "line.rkt" "misc.rkt")
(provide b-end b-goto b-gosub b-return b-for b-next)

(define (b-end) (raise (end-program-signal)))
(define (b-goto expr) (raise (change-line-signal expr)))

(define return-ccs empty)

(define (b-gosub num-expr)
  (let/cc here-cc
    (push! return-ccs here-cc)
    (b-goto num-expr)))

(define (b-return)
  (when (empty? return-ccs)
    (raise-line-error "return without gosub"))
  (define top-cc (pop! return-ccs))
  (top-cc (void)))

(define next-funcs (make-hasheq))

(define-macro-cases b-for
  [(_ LOOP-ID START END) #'(b-for LOOP-ID START END 1)]
  [(_ LOOP-ID START END STEP)
   #'(b-let LOOP-ID
            (let/cc loop-cc
              (hash-set! next-funcs
                         'LOOP-ID
                         (lambda ()
                           (define next-val
                             (+ LOOP-ID STEP))
                           (if (next-val
                                . in-closed-interval? .
                                START END)
                               (loop-cc next-val)
                               (hash-remove! next-funcs
                                             'LOOP-ID))))
              START))])

(define (in-closed-interval? x start end)
  ((if (< start end) <= >=) start x end))

(define-macro (b-next LOOP-ID)
  #'(begin
      (unless (hash-has-key? next-funcs 'LOOP-ID)
        (raise-line-error
         (format "`next ~a` without for" 'LOOP-ID)))
      (define func (hash-ref next-funcs 'LOOP-ID))
      (func)))