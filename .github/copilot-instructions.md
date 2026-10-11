# Copilot Instructions

Tiny Common Lisp library (ASDF system `promise`) implementing call-by-need promises. No runtime dependencies, no linter.

## Build / load

```lisp
(asdf:load-system :promise)   ; from a REPL, with this directory on the ASDF source registry
```

Command-line check (SBCL): `sbcl --noinform --eval "(asdf:load-asd (truename \"promise.asd\"))" --eval "(asdf:load-system :promise)" --quit`

## Tests (FiveAM)

Separate system `promise-test` (`promise-test.asd`; `test-package.lisp`, `test.lisp`; needs `fiveam` via Quicklisp/ASDF).

```
sbcl --noinform --non-interactive --eval "(require :asdf)" --eval "(asdf:load-asd (truename \"promise.asd\"))" --eval "(asdf:load-asd (truename \"promise-test.asd\"))" --eval "(asdf:test-system :promise-test)"
```

Single test (after loading `promise-test`): `(fiveam:run! 'promise-test::force-memoizes)`. The suite is `PROMISE-TEST:PROMISE-SUITE`.

## Architecture

- `package.lisp` defines package `"PROMISE"` (uses only `COMMON-LISP`) and its exports. Any new public symbol must be added to `:export` there.
- `promise.lisp` holds everything: the `PROMISE` class (slots `forced?` and `values-or-thunk`), `DELAY` macro, `FORCE`, `FORCED?`, `PROMISE-VALUES`.
- `values-or-thunk` is dual-purpose: a thunk before forcing, then replaced by the *list* of all return values afterwards. Promises memoize multiple values (`multiple-value-list` / `values-list`).
- `FORCE` is re-entrancy safe: if forcing recursively forces the same promise, the inner result wins and the outer result is discarded (the `unless forced?` re-check). Preserve this.
- Public functions start with `(check-type promise promise)` and access slots via `slot-value` (no accessors by design).

## Conventions

- Predicates end in `?` (Scheme style), not `-p`.
- Files begin with `;;; -*- Lisp -*-`; the package is written as a string designator (`"PROMISE"`).
- If adding CLOS slots, prefer immutability: `:reader` only (named `GET-<slot>`) unless mutation is intended.
