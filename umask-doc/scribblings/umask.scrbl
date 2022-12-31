#lang scribble/manual
@require[@for-label[umask
                    racket/base
                    racket/function
                    racket/file]]

@title{umask}
@author{Winston Weinert}

@hyperlink["https://unmaintained.tech/"]{@image{unmaintained.svg}}

@defmodule[umask]

Set the default permissions on a Unix-like operating system.  This allows one
to control who may read from/write to/execute a file upon creation.

@defproc[(valid-umask? [mask any]) boolean?]{
Predicate to determine if a value can be used passed into the @racket[umask]
procedure.
}

@defproc*[([(umask) valid-umask?]
           [(umask [mask valid-umask?]) void?])]{

Behaves like the unix
@hyperlink["https://en.wikipedia.org/wiki/Umask"]{umask(2)} system call.  If
invoked with no arguments, this procedure returns the current umask (file mode
creation mask).  If invoked with argument @racket[mask], set the current umask
to the value of @racket[mask] and returns @racket[(void)].

}

@defform[(with-umask umask-expr body ...) #:contracts ([umask-expr valid-umask?])]{

Temporarily set the umask to @racketid[umask-expr] when evaluating @racketid[body ...].

}

@section{Caveats}

@racket[copy-file] does not respect umask semantics.

@section{Examples}

Get input from the user then save it to a temporary file that will be only
readable by the current user.

@codeblock|{
(with-umask #o077
  (define temporary-file (make-temporary-file))
  (define secret (read-line))
  (printf "Secret saved to ~a.\n" temporary-file)
  (with-output-to-file temporary-file (thunk (displayln secret))))
}|


Get the umask

@codeblock|{
(umask)
}|

Set the umask so subsequently files are only readable as the current user (and root).

@codeblock|{(umask #o077)}|

@section{Project Information}

@itemlist[
 @item{MIT/X Licensed}
 @item{@hyperlink["https://github.com/winny-/umask"]{Source code on GitHub}}
 @item{@hyperlink["https://racket.discourse.group/t/umask-set-default-file-permissions/613"]{Announcement and library discussion on the Racket Discourse}}
]

@section{Tested Platforms}

@itemlist[
  @item{Gentoo GNU/Linux using glibc 2.33, Racket 8.3 from Portage}
  @item{Alpine Linux using musl 1.2.2, Racket 7.7 packaged by Alpine}
  @item{Mac OS X Big Sur, Racket 8.3 from Homebrew}
]

Windows is not supported because @hyperlink["https://www.reddit.com/r/sysadmin/comments/5fm9lg/windows_equivalent_of_umask/"]{umask semantics are not available on Windows}.
