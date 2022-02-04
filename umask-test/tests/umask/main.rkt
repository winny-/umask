#lang racket

(require umask
         rackunit
         rackunit/docs-complete)

(test-case "documentation completeness"
  (check-docs 'umask))

(test-case "valid-umask? is #t"
  (for ([v '(0 #o777 #o755 #o444 #o600)])
    (check-true (valid-umask? v) (~a v))))

(test-case "valid-umask is #f"
  (for ([v (list -1 7/2 6.532 #o1000 (- #o1000) #t #f (void) 'a "a")])
    (check-false (valid-umask? v) (~a v))))

(test-case "Get the umask"
  (define mask (umask))
  (check-pred valid-umask? mask))

(test-case "Set umask"
  (define file (make-temporary-file))
  (delete-file file)
  (after
   (umask #o700)
   (display-to-file 'datum file)
   (check-equal? (file-or-directory-permissions file 'bits) #o066)
   (with-handlers ([exn:fail:filesystem? void])
     (delete-file file))))

(test-case "with-umask changes umask"
  (define file (make-temporary-file))
  (delete-file file)
  (after
   (with-umask #o246
     (display-to-file 12345 file))
   (check-equal? (file-or-directory-permissions file 'bits) #o420)
   (with-handlers ([exn:fail:filesystem? void])
     (delete-file file))))

(test-case "with-umask restores umask"
  (umask #o222)
  (with-umask #o124
    (void))
  (check-equal? (libc-umask 0) #o222))

(test-case "with-umask restores umask on exception"
  (umask #o111)
  (with-handlers ([exn? void])
    (with-umask #o521
      (error 'weee)))
  (check-equal? (libc-umask 0) #o111))

(test-equal?
 "with-umask return value"
 (with-umask #o123 (begin 'this 'thing)) 'thing)

(test-case "with-umask can use define in body"
  (with-umask #o567
    (define v "value")
    v)
  (check-true #t))

(test-case "umask works across threads"
  (umask #o765)
  (thread-wait
   (thread
    (thunk
     (umask #o234))))
  (check-equal? (libc-umask 0) #o765))
