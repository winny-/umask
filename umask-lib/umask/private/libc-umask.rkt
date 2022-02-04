#lang racket/base

(require (rename-in ffi/unsafe [-> ffi->])
         ffi/unsafe/define)

(provide libc-umask)

(define-ffi-definer define-libc (ffi-lib "libc" "6"))
(define-libc libc-umask (_fun _uint32 ffi-> _uint32) #:c-id umask)
