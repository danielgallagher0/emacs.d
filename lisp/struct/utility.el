(require 'cl)
(require 'eieio)

;; Define a macro that acts like the common list defparameter: it
;; updates the variable every time it is called.
(defmacro defparameter (parameter value)
  (progn
    `(defvar ,parameter)
    `(setq ,parameter ,value)))

;; This function converts a string to a valid C++ identifier using
;; camel case.  It removes all non-word characters, capitalizes
;; separate words, then slams the words together.
(defun pascal-case (str)
  (replace-regexp-in-string "[^[:word:]]" "" (capitalize str)))

;; This function uncapitalizes the first letter of the string.  If the
;; first letter is not an uppercase character, this function returns
;; a string identical to the one given to it.
(defun uncapitalize (str)
  (concat (downcase (substring str 0 1)) (substring str 1)))

;; This function converts a string to a valid C++ identifier using
;; camel case.  It removes all non-word characters, capitalizes
;; separate words, then slams the words together.
(defun camel-case (str)
  (uncapitalize (pascal-case str)))

(defun cpp-upcase (str)
  (upcase (replace-regexp-in-string "-" "_" str)))
