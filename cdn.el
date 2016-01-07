(defmacro defcdn (lib url &optional style-url)
  (let ((funsym (intern (concat "cdn-" (join (split-string (symbol-name lib)) "-")))))
    (if style-url
        `(defun ,funsym ()
           (interactive)
           (insert (format "    <link ref=\"stylesheet\" href=\"%s\">\n" ,style-url))
           (insert (format "    <script src=\"%s\"></script>\n" ,url)))
      `(defun ,funsym ()
         (interactive)
         (insert (format "    <script src=\"%s\"></script>\n" ,url))))))

(defcdn jquery
  "//ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js")
(defcdn jquery-ui
  "//ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/jquery-ui.min.js"
  "//ajax.googleapis.com/ajax/libs/jqueryui/1.11.4/themes/smoothness/jquery-ui.css")
(defcdn jquery-mobile
  "//ajax.googleapis.com/ajax/libs/jquerymobile/1.4.5/jquery.mobile.min.js"
  "//ajax.googleapis.com/ajax/libs/jquerymobile/1.4.5/jquery.mobile.min.css")
