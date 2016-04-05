(load "struct/utility")
(load "struct/types")
(load "struct/struct")
(load "struct/enum")
(load "struct/enum-declaration")
(load "struct/enum-to-string")
(load "struct/struct-declaration")
(load "struct/struct-default-ctor")
(load "struct/struct-field-ctor")
(load "struct/struct-equality")
(load "struct/struct-diff")

(defun struct-fn (generator-type structure-type)
  (interactive "xGenerator type: \nxStructure type: ")
  (let ((generator (if (listp generator-type)
                       (apply #'make-instance generator-type)
                     (make-instance generator-type)))
        (struct (if (listp structure-type)
                    (apply #'make-instance structure-type)
                  (make-instance structure-type))))
    (generate-code generator struct)))
