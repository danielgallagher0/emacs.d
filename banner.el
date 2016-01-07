(defun insert-banner (str)
  (interactive "sBanner text: ")
  (insert (format "//******************\n// %s\n//******************\n" (upcase str))))

(defun join-impl (result lst join-str)
  (if (null lst)
      result
    (join-impl (concat (concat result join-str) (car lst)) (cdr lst) join-str)))

(defun join (strings join-str)
  (if strings
      (join-impl (car strings) (cdr strings) join-str)
    ""))

(defun symbolify (str)
  (join (split-string str) "-"))

(defmacro defbanner (name)
  (let ((funsym (intern (symbolify (concat "banner-" name)))))
    `(defun ,funsym ()
       (interactive)
       (insert-banner ,name))))

(defbanner "includes")
(defbanner "class")
(defbanner "public")
(defbanner "private")
(defbanner "definitions")
(defbanner "protected")
(defbanner "private slots")
(defbanner "public slots")
(defbanner "protected slots")
(defbanner "tests")
(defbanner "structures")
