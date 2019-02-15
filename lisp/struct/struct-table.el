(defclass struct-table-generator (generator)
  ((class :initarg :class)))

(defmethod generate-preamble ((g struct-table-generator) s)
  (format "// static //
cDbTable %s::%sTable( void )
{
    cDbTable table( Table_%s );
" (slot-value g 'class) (pascal-case (lisp-name s)) (cpp-upcase (lisp-name s))))

(defmethod generate-postamble ((g struct-table-generator) s)
  "
    return table;
}
")

(defmethod field-column-name (field-description name structure)
  (let ((explicit-column (plist-get field-description :db-column)))
    (if explicit-column
        (format "%s" (cpp-upcase explicit-column))
      (format "%s_%s" (cpp-upcase (lisp-name structure)) (cpp-upcase name)))))

(defmethod field-data-type (field description)
  (error "field-data-type not implemented for type %s" (svref field 2)))

(defmethod field-data-type ((field bool) description)
  "Boolean()")

(defmethod field-data-type ((field char) description)
  "Byte()")

(defmethod field-data-type ((field short) description)
  "Integer()")

(defmethod field-data-type ((field int) description)
  "Integer()")

(defmethod field-data-type ((field long) description)
  "Long()")

(defmethod field-data-type ((field double) description)
  "Real()")

(defmethod field-data-type ((field float) description)
  "Real()")

(defmethod field-data-type ((field qstring) description)
  (format "VarChar( %s )"
          (let ((explicit-length (plist-get description :db-length)))
            (if explicit-length
                explicit-length
              "TEXT_LENGTH"))))

(defmethod field-data-type ((field qdate) description)
  "Date()")

(defmethod field-data-type ((field qdatetime) description)
  "DateTime()")

(defmethod field-data-type ((field enum-type) description)
  "Byte()")

(defun db-data-type (field description)
  (let ((explicit-type (plist-get description :db-type)))
    (if explicit-type
        explicit-type
      (field-data-type field description))))

(defmethod generate-field ((g struct-table-generator) s f)
  (let ((field (apply #'make-instance (cdr f))))
    (format "    table.FieldAdd( Column_%s, cColumnDataType::%s );\n"
            (field-column-name f (field-name f) s)
            (db-data-type field f))))
