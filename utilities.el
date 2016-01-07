(defun zap-up-to-char (n c)
  (interactive "p\ncZap to char: ")
  (zap-to-char n c)
  (insert c)
  (backward-char 1))

(defun backward-buffer ()
  (interactive)
  (other-window -1))

(defun forward-buffer ()
  (interactive)
  (other-window 1))

(defun n-spaces (n &optional prefix)
    (if (<= n 0)
            (or prefix "")
        (n-spaces (1- n) (concat (or prefix "") " "))))

(defun insert-spaces (count)
    (insert (n-spaces count)))

(defun pad-to-column (col)
    (interactive "nColumn Number: ")
    (insert-spaces (max 0 (- col (current-column)))))

(defun replace-text-everywhere (from-string to-string)
  (save-excursion
    (beginning-of-buffer)
    (replace-string from-string to-string)))

(defun replace-text-in-files (file-list from-string to-string)
  (if file-list
      (progn
        (switch-to-buffer (car file-list))
        (replace-text-everywhere from-string to-string)
        (replace-text-in-files (cdr file-list) from-string to-string))))

(defun number-line-reset ()
  (interactive)
  (set-register ?a -1))

(defun number-line ()
  (interactive)
  (end-of-line)
  (insert (format " // %d" (set-register ?a (1+ (get-register ?a)))))
  (next-line)
  (beginning-of-line))

(defun string/begins-with (s begins)
  (let ((blength (length begins)))
    (cond ((>= (length s) blength)
           (string-equal (substring s 0 blength) begins))
          (t nil))))

(defun string/ends-with (s ends)
  (let ((elength (length ends)))
    (cond ((>= (length s) elength)
           (string-equal (substring s (- elength)) ends))
          (t nil))))

(defun sixth (lst)
  (car (cdr (cdr (cdr (cdr (cdr lst)))))))

(defun current-year ()
  (sixth (decode-time (current-time))))
