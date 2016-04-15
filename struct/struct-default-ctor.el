;;; This file defines a code generator for a structure's default
;;; constructor.  This initializes all primitive types to default
;;; values, and leaves object types out of the definition so they are
;;; default-initialized.

(defclass struct-default-ctor (generator)
  ((namespace :initarg :namespace :initform nil)
   (first-field)))

(defmethod generate-preamble ((g struct-default-ctor) s)
  (oset g first-field t)
  (format "%s%s::%s()\n"
          (let ((ns (slot-value g 'namespace)))
            (if ns (concat ns "::") ""))
          (cpp-name s)
          (cpp-name s)))

(defmethod generate-field ((g struct-default-ctor) s f)
  (let ((field (make-instance (field-symbol f))))
    (if (primitive-p field)
        (prog1
            (format "    %s %s( %s )\n"
                    (if (slot-value g 'first-field) ":" ",")
                    (field-name f)
                    (primitive-default-value field))
          (oset g first-field nil))
      "")))

(defmethod generate-postamble ((g struct-default-ctor) f)
  "{\n}\n")
