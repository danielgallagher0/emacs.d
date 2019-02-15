(defclass enum-to-string-generator (generator)
  ())

(defmethod generate-enum-preamble ((g enum-to-string-generator) e)
  (format
"template<>
char* QTest::toString( const %s& %s )
{
    QString str;

    switch( %s )
    {
" (cpp-name e) (var-name e) (var-name e)))

(defmethod generate-enum-value ((g enum-to-string-generator) e v)
  (format "    case %s: str = \"%s\"; break;\n"
          (enum-value e (cadr v)) (enum-value e (cadr v))))

(defmethod generate-enum-postamble ((g enum-to-string-generator) e)
  (format
"    default:
        str = QString( \"(Unknown: %%1)\" ).arg( static_cast<int>( %s ) );
        break;
    }

    return qstrdup( str.trimmed().toLatin1().data() );
}
" (var-name e)))
