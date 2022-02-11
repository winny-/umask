#lang racket/base

(require (rename-in ffi/unsafe [-> ffi->])
         ffi/unsafe/define)

(provide libc-umask)

(define-ffi-definer define-libc
  (case (system-type 'os)
    [(unix) (ffi-lib "libc" "6")]
    [(macosx) (ffi-lib "libSystem")]
    [else (raise (exn:fail:unsupported
                  "Unsupported OS does not support umask syscall."
                  (current-continuation-marks)))]))

(define-libc libc-umask (_fun _uint32 ffi-> _uint32) #:c-id umask)
