;;; -*- Lisp -*-

(in-package "PROMISE-TEST")

(def-suite promise-suite :description "Tests for the PROMISE library.")
(in-suite promise-suite)

(test delay-is-lazy
  (let ((count 0))
    (let ((p (delay (incf count))))
      (is (typep p 'promise))
      (is (= 0 count))
      (is-false (forced? p)))))

(test force-returns-value
  (is (= 42 (force (delay (+ 40 2)))))
  (let ((p (delay 1)))
    (force p)
    (is-true (forced? p))))

(test force-memoizes
  (let* ((count 0)
         (p (delay (incf count))))
    (is (= 1 (force p)))
    (is (= 1 (force p)))
    (is (= 1 count))))

(test force-multiple-values
  (let ((p (delay (values 1 2 3))))
    (is (equal '(1 2 3) (multiple-value-list (force p))))
    (is (equal '(1 2 3) (multiple-value-list (force p))))))

(test force-zero-values
  (let ((p (delay (values))))
    (is (null (multiple-value-list (force p))))
    (is-true (forced? p))))

(test force-rejects-non-promise
  (signals type-error (force 3))
  (signals type-error (forced? 3))
  (signals type-error (promise-values 3 #'list #'list)))

(test force-reentrant
  ;; The inner (recursive) force wins; the outer result is discarded.
  (let* ((count 0)
         (p nil))
    (setf p (delay (if (= (incf count) 1)
                       (progn (force p) :outer)
                       :inner)))
    (is (eq :inner (force p)))
    (is (eq :inner (force p)))
    (is (= 2 count))))

(test force-error-leaves-unforced
  (let ((p (delay (error "boom"))))
    (signals error (force p))
    (is-false (forced? p))))

(test promise-values-dispatch
  (let ((p (delay (values 1 2))))
    (is (eq :unforced (promise-values p (lambda (&rest v) (declare (ignore v)) :forced)
                                      (lambda () :unforced))))
    (force p)
    (is (equal '(1 2) (promise-values p #'list (lambda () :unforced))))))

(test print-object-shows-state
  (let ((p (delay 1)))
    (is (search "unforced" (princ-to-string p)))
    (force p)
    (let ((s (princ-to-string p)))
      (is (search "forced" s))
      (is-false (search "unforced" s)))))
