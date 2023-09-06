(defun update-copyright ()
  (interactive)
  (save-excursion
    (beginning-of-buffer)
    (let ((start-years (search-forward " Copyright (c) " nil t))
          (current-year (cadddr (cddr (decode-time (current-time))))))
      (if start-years
          (let ((end-years (search-forward-regexp "\\([[:digit:]]\\{4\\}\\(-[[:digit:]]\\{4\\}\\)?, ?\\)+" nil t))
                (previous-year (1- current-year)))
            (if end-years
                (let ((years (buffer-substring start-years end-years)))
                  (let ((current-year-idx (search (format "%d" current-year) years))
                        (range-ending-last-year-idx (search (format "-%d" previous-year) years))
                        (last-year-idx (search (format "%d" previous-year) years)))
                    (if (not current-year-idx)
                        (if range-ending-last-year-idx
                            (replace-string (format "%d" previous-year) (format "%d" current-year) nil start-years end-years)
                          (if last-year-idx
                              (replace-string (format "%d" previous-year) (format "%d-%d" previous-year current-year) nil start-years end-years)
                            (insert (format "%d, " current-year)))))))))))))
(add-hook 'before-save-hook #'update-copyright)

(defmacro defcopyright (nickname company)
  (let ((funsym (intern (concat "insert-" (join (split-string (symbol-name nickname)) "-") "-copyright"))))
    `(defun ,funsym ()
       (interactive)
       (let ((copyright-string (format "Copyright (c) %d, %s." (current-year) ,company)))
         (cond
          ((or (eq major-mode 'c-mode)
               (eq major-mode 'c++-mode))
           (if (string/ends-with (buffer-name) ".h")
               (insert-include-guard))
           (beginning-of-buffer)
           (insert (format "/**
 * \\file
 *
 * %s
 * All rights reserved.
 *
 *
 */

" copyright-string))
           (if (not (string/ends-with (buffer-name) ".h"))
               (progn
                 (banner-includes)
                 (insert (format "\n#include \"%s.h\"\n" (substring (buffer-name) 0 (position ?. (buffer-name)))))
                 (previous-line 5)))
           (previous-line 3)
           (end-of-line)
           (insert " "))
          ((eq major-mode 'python-mode)
           (beginning-of-buffer)
           (insert (format "\"\"\"\n\n%s\nAll rights reserved.\n\n\"\"\"\n" copyright-string))
           (beginning-of-buffer)
           (forward-char 3)))))))


(defcopyright turncare "TurnCare Inc")
(defcopyright self "Daniel Gallagher")

