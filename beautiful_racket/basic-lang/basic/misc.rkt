#lang br
(provide b-rem b-print)

(define (b-rem val) (void))
(define (b-print . vals)
  (displayln (string-append* (map ~a vals))))