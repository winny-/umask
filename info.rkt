#lang info
(define collection "umask")
;; TODO split tests out into own package.
(define deps '("base" "rackunit-lib" "racket-index"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/umask.scrbl" () (library))))
(define pkg-desc "Description Here")
(define version "0.2")
(define pkg-authors '("Winston Weinert"))
(define license '(MIT))
(define pkg-info "umask (file creation mask) utilities")
