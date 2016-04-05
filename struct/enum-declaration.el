(defclass enum-declaration-generator (generator)
  ())

(defmethod generate-enum-preamble ((g enum-declaration-generator) e)
  (format "enum %s\n{\n" (cpp-name e)))

(defmethod generate-enum-value ((g enum-declaration-generator) e v)
  (format "    %s = %d,\n" (enum-value e (cadr v)) (cadr v)))

(defmethod generate-enum-postamble ((g enum-declaration-generator) e)
  "};\n")
