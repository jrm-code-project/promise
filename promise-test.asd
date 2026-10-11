;;; -*- Lisp -*-

(defsystem promise-test
  :depends-on ("promise" "fiveam")
  :components ((:file "test-package")
               (:file "test" :depends-on ("test-package")))
  :perform (test-op (operation component)
             (symbol-call :fiveam :run! (find-symbol "PROMISE-SUITE" "PROMISE-TEST"))))
