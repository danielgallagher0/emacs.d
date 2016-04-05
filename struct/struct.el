;;; This file defines the basic macros and methods for structures and
;;; code generators.

(load "struct/utility")

(defmacro define-structure (type &rest fields)
  `(progn
     (defclass ,type (user-type)
       ())

     (defmethod cpp-name ((obj ,type))
       (format "s%s" (pascal-case (symbol-name ,type))))

     (defmethod variable-name ((obj ,type))
       (format "%s" (camel-case (symbol-name ,type))))

     (defmethod fields ((obj ,type))
       ',fields)

     ',type))

(defun field-symbol (f)
  (cadr f))

(defun field-name (f)
  (camel-case (symbol-name (car f))))

(defun field-type (f)
  (let ((field (apply #'make-instance (cdr f))))
    (cpp-name field)))

(defclass generator ()
  ()
  "Base class for code generators")

(defmethod generate-preamble (g s)
  "")

(defmethod generate-field (g s f)
  "")

(defmethod generate-postamble (g s)
  "")

(defmethod field-separator (g)
  #'concat)

(defun code-string (generator structure)
  (concat (generate-preamble generator structure)
          (reduce (field-separator generator) (mapcar #'(lambda (field) (generate-field generator structure field)) (fields structure)))
          (generate-postamble generator structure)))

(defun generate-code (generator structure)
  (insert (code-string generator structure)))
