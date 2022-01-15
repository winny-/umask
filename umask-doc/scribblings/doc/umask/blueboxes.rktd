199
((3) 0 () 1 ((q lib "umask/main.rkt")) () (h ! (equal) ((c form c (c (? . 0) q with-umask)) q (142 . 4)) ((c def c (c (? . 0) q valid-umask?)) q (0 . 3)) ((c def c (c (? . 0) q umask)) q (62 . 3))))
procedure
(valid-umask? mask) -> boolean?
  mask : any
procedure
(umask mask) -> (or void valid-umask?)
  mask : valid-umask?
syntax
(with-umask umask-expr body ...)
 
  umask-expr : valid-umask?
