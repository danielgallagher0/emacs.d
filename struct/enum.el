; (load "utility")

(defclass enum-type ()
  ()
  "Base class for enum types")

(defmethod parameter-type ((e enum-type))
  (cpp-name e))

(defmethod enum-value ((e enum-type) n)
  (let ((value (nth n (enum-values e))))
    (format "%s_%s" (value-prefix e) (cpp-upcase (symbol-name (car value))))))

(defmethod primitive-default-value ((e enum-type))
  (enum-value e 0))

(defmethod primitive-p ((e enum-type))
  t)

(defmacro define-enum (type &rest values)
  `(progn
     (defclass ,type (enum-type)
       ())

     (defmethod value-prefix ((obj ,type))
       (pascal-case (symbol-name ,type)))

     (defmethod cpp-name ((obj ,type))
       (format "e%s" (value-prefix obj)))

     (defmethod var-name ((obj ,type))
       (camel-case (symbol-name ,type)))

     (defmethod enum-values ((obj ,type))
       ',(let ((n 0))
           (mapcar #'(lambda (s)
                       (let ((r (list s n)))
                         (setq n (1+ n))
                         r))
                   values)))

     ',type))

(defmethod generate-enum-preamble (g e)
  "")

(defmethod generate-enum-value (g e v)
  "")

(defmethod generate-enum-postamble (g e)
  "")

(defmethod enum-value-separator (g)
  #'concat)

(defun enum-code-string (generator enum)
  (concat (generate-enum-preamble generator enum)
          (reduce (enum-value-separator generator) (mapcar #'(lambda (val) (generate-enum-value generator enum val)) (enum-values enum)))
          (generate-enum-postamble generator enum)))

(defun generate-enum-code (generator enum)
  (insert (enum-code-string generator enum)))
