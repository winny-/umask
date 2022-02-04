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
         with-umask
         libc-umask)

(define-ffi-definer define-libc (ffi-lib "libc" "6"))
(define-libc libc-umask (_fun _uint32 ffi-> _uint32) #:c-id umask)

(define valid-umask? (integer-in 0 #o777))

(define umask (make-parameter (libc-umask 0)
                              (λ (mask)
                                (unless (valid-umask? mask)
                                  (raise-type-error 'umask "A umask value should be between 0 and #o077 inclusive"))
                                (libc-umask mask)
                                mask)))

(define-syntax-rule (with-umask new-umask body body-rest ...)
  (parameterize ([umask new-umask])
    body
    body-rest ...))

