;;; This file defines a code generator for structure declarations.

(defun all-field-parameters (s)
  (let ((all-params (reduce #'(lambda (a b) (concat a ", " b))
                            (mapcar #'(lambda (f) (format "%s %s_" (parameter-type (apply #'make-instance (cdr f)))
                                                          (field-name f)))
                                    (fields s)))))
    all-params))

(defclass struct-declaration-generator (generator)
  ()
  "Create the struct definition")

(defmethod generate-preamble ((g struct-declaration-generator) s)
  (let ((name (cpp-name s)))
    (format
"struct %s
{
    %s();
    %s( %s );

" name name name (all-field-parameters s))))

(defmethod generate-field ((g struct-declaration-generator) s f)
  (format "    %s %s;%s\n" (field-type f) (field-name f)
          (let ((comment (plist-get f :comment)))
            (if comment
                (concat " // " comment)
              ""))))

(defmethod generate-postamble ((g struct-declaration-generator) s)
  (format "};\n"))
