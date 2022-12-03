umask
=====

[![CI](https://github.com/winny-/umask/actions/workflows/ci.yml/badge.svg)](https://github.com/winny-/umask/actions/workflows/ci.yml) [![raco doc umask](https://img.shields.io/badge/raco%20doc-umask-blue)](https://docs.racket-lang.org/umask/index.html)

Umask library for Racket.

```bash
raco pkg install umask
```

Caveats
-------

Does not work with `copy-file` because it defeats umask semantics.
