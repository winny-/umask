#lang racket/base

(require racket/contract/base
         racket/function
         "private/libc-umask.rkt")

(provide (contract-out [umask (->i ()
                                   ([mask valid-umask?])
                                   [result
                                    (mask)
                                    (begin
                                      (if (valid-umask? mask)
                                          void?
                                          valid-umask?))])]
                       [valid-umask? (-> any/c boolean?)])
         with-umask)

(define valid-umask? (integer-in 0 #o777))

(define (umask [mask #f])
  (case mask
    [(#f)
     (define last-mask (libc-umask 0))
     (libc-umask last-mask)
     last-mask]
    [else
     (libc-umask mask)
     (void)]))

(define-syntax-rule (with-umask new-umask body0 body* ...)
  (if (valid-umask? new-umask)
      (let ([old-umask (libc-umask new-umask)])
        (dynamic-wind void (thunk body0 body* ...) (thunk (umask old-umask))))
      (raise-arguments-error 'with-umask "A umask value should be between 0 and #o777 inclusive" "new-umask" new-umask)))

