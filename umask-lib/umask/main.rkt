#lang racket/base

(require racket/contract/base
         (rename-in ffi/unsafe [-> ffi->])
         ffi/unsafe/define)

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

(define-ffi-definer define-libc (ffi-lib "libc" "6"))
(define-libc libc-umask (_fun _uint32 ffi-> _uint32) #:c-id umask)

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

(define-syntax-rule (with-umask new-umask body body-rest ...)
  (if (valid-umask? new-umask)
      (let ([old-umask (libc-umask new-umask)])
        (begin0
            (let ()
              body
              body-rest ...)
          (umask old-umask)))
      (raise-arguments-error 'with-umask "A umask value should be between 0 and #o777 inclusive" "new-umask" new-umask)))

