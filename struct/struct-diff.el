xb;;; This file defines a generator for creating structure difference
;;; functions for test comparisons.

(defclass struct-diff-generator (generator)
  ())

(defmethod generate-preamble ((g struct-diff-generator) s)
  (let ((name (cpp-name s))
        (var-name (variable-name s)))
    (format
"char* Diff( const %s& t1, const %s& t2, const %s& %s, const QString& prefix = \"%s.\" )
{
    QString str;

" name name name var-name var-name)))

(defmethod generate-postamble ((g struct-diff-generator) s)
  "
    return qstrdup( str.trimmed().toLatin1().data() );
}
")

(defmethod field-inequality (f t1 t2)
  (format "%s != %s" t1 t2))

(defmethod field-inequality ((f double) t1 t2)
  (format "!FloatingEqual( %s, %s )" t1 t2))

(defmethod field-inequality ((f cfloat) t1 t2)
  (format "!FloatingEqual( %s, %s )" t1 t2))

(defmethod field-difference (f f-name tmpl)
  (format "prefix + \"%s: \" + QString( QTest::toString( %s ) ) + \"\\n\"" f-name tmpl))

(defmethod field-difference ((f user-type) f-name tmpl)
  (format "Diff( t1.%s, t2.%s, %s.%s, prefix + \"%s.\" ) + QString( \"\\n\"" f-name f-name tmpl f-name f-name))

(defmethod generate-field ((g struct-diff-generator) s f)
  (let ((field (make-instance (field-symbol f)))
        (name (field-name f))
        (struct-tmpl (variable-name s)))
    (format "    if( %s )
        str += %s;
" (field-inequality field (concat "t1." name) (concat "t2." name)) (field-difference field name (concat struct-tmpl "." name)))))
