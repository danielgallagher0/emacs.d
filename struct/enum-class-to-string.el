(defclass enum-class-to-string (generator)
  ())

(defmethod generate-enum-preamble ((g enum-class-to-string) e)
  (format "QString ToString( %s %s )
{
    QString str;

    switch( %s )
    {
" (cpp-name e) (var-name e) (var-name e)))

(defmethod generate-enum-postamble ((g enum-class-to-string) e)
  (format "    default:
        str = QString( \"(Unknown %s: %%1)\" ).arg( static_cast<int>( %s ) );
        break;
    }

    return str;
}
" (value-prefix e) (var-name e)))

(defmethod generate-enum-value ((g enum-class-to-string) e v)
  (let ((var-name (enum-class-value e (cadr v))))
    (format "    case %s: str = \"%s\"; break;\n" var-name var-name)))
