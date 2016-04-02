;;; This file defines a code generator for a structure's constructor
;;; that includes all data.

(defclass struct-field-ctor (generator)
  ((namespace :initarg :namespace :initform nil)
   (first-field)))

(defmethod generate-preamble ((g struct-field-ctor) s)
  (oset g first-field t)
  (format "%s%s::%s( %s )\n"
          (let ((ns (slot-value g 'namespace)))
            (if ns (concat ns "::") ""))
          (cpp-name s)
          (cpp-name s)
          (all-field-parameters s)))

(defmethod generate-field ((g struct-field-ctor) s f)
  (prog1
      (let ((name (field-name f)))
        (format "    %s %s( %s_ )\n"
                (if (slot-value g 'first-field) ":" ",")
                name name))
    (oset g first-field nil)))

(defmethod generate-postamble ((g struct-field-ctor) f)
  "{\n}\n")
