;;; This file defines a code generator to convert a structure to a
;;; QVariantMap (for loading into a JSON object).

(defclass struct-to-variant-map (generator)
  ())

(defmethod generate-preamble ((g struct-to-variant-map) s)
  (format "QVariantMap ToVariantMap( const %s& %s )
{
    QVariantMap map;
" (cpp-name s) (variable-name s)))

(defmethod generate-postamble ((g struct-to-variant-map) s)
  "
    return map;
}
")

(defmethod field-to-variant (f name)
  (format "%s" name))

(defmethod field-to-variant ((f user-type) name)
  (format "ToVariantMap( %s )" name))

(defmethod field-to-variant ((f enum-type) name)
  (format "ToString( %s )" name))

(defmethod field-to-variant ((f std-vector) name)
  (format "ToVariantList( %s )" name))

(defmethod field-to-variant ((f c-array) name)
  (format "ToVariantList( %s )" name))

(defmethod field-to-variant ((f std-array) name)
  (format "ToVariantList( %s )" name))

(defmethod generate-field ((g struct-to-variant-map) s f)
  (let ((name (field-name f))
        (field (make-instance (field-symbol f))))
    (format "    map[ \"%s\" ] = %s;\n" name (field-to-variant field (concat (variable-name s) "." name)))))
