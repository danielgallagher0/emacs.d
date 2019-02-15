;;; This file defines a generator for creating structure equality
;;; (operator==) definitions.

(defclass struct-strict-equality-generator (generator)
  ())

(defclass struct-equality-generator (struct-strict-equality-generator)
  ())

(defmethod generate-preamble ((g struct-strict-equality-generator) s)
  (let ((name (cpp-name s)))
    (format "bool operator==( const %s& t1, const %s& t2 )\n{\n    return( " name name)))

(defmethod generate-postamble ((g struct-strict-equality-generator) s)
  (let ((name (cpp-name s)))
    (format " );\n}\n\nbool operator!=( const %s& t1, const %s& t2 )\n{\n    return !( t1 == t2 );\n}\n"
            name name)))

(defmethod field-equality ((f data-type) t1 t2)
  (concat t1 " == " t2))

(defmethod field-equality ((f enum-type) t1 t2)
  (concat t1 " == " t2))

(defmethod field-equality ((f cfloat) t1 t2)
  (concat "FloatingEqual( " t1 ", " t2 " )"))

(defmethod field-equality ((f double) t1 t2)
  (concat "FloatingEqual( " t1 ", " t2 " )"))

(defmethod field-separator ((g struct-strict-equality-generator))
  #'(lambda (a b) (concat a " &&\n            " b)))

(defmethod generate-field ((g struct-equality-generator) s f)
  (let ((field (make-instance (field-symbol f)))
        (name (field-name f)))
    (field-equality field (concat "t1." name) (concat "t2." name))))

(defmethod generate-field ((g struct-strict-equality-generator) s f)
  (let ((name (field-name f)))
    (concat "t1." name " == t2." name)))
