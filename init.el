
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(backup-directory-alist (quote (("." . "/home/synthesis/.backup"))))
 '(c-basic-offset 4)
 '(indent-tabs-mode nil)
 '(initial-buffer-choice t)
 '(package-selected-packages
   (quote
    (yaml-mode markdown-mode toml-mode rust-mode web w3m svg-clock php-mode code-headers cl-lib cl-format c-eldoc auto-complete-clang auto-complete android-mode)))
 '(safe-local-variable-values
   (quote
    ((todo-categories "Calorie" "Todo" "CalorieKeeper"))))
 '(speedbar-directory-unshown-regexp "^\\(CVS\\|RCS\\|SCCS\\|.deps\\)\\'")
 '(speedbar-frame-parameters
   (quote
    ((minibuffer)
     (width . 20)
     (border-width . 0)
     (menu-bar-lines . 0)
     (toolbar-lines . 0)
     (unsplittable . t)
     (set-background-color "black"))))
 '(speedbar-supported-extension-expressions
   (quote
    (".[ch]\\(\\+\\+\\|pp\\|c\\|h\\|xx\\)?" ".tex\\(i\\(nfo\\)?\\)?" ".el" ".emacs" ".l" ".lsp" ".p" ".java" ".f\\(90\\|77\\|or\\)?" ".ad*" ".p[lm]" ".tcl" ".m" ".scm" ".pm" ".py" ".g" ".s?html" "[Mm]akefile\\(\\.in\\|am\\)?" "configure.ac" ".ml*" ".tig" ".\\(ll\\|yy\\)")))
 '(tab-width 4)
 '(vc-make-backup-files t))

; Generic Emacs configuration
(require 'cl)
(require 'eieio)
(global-font-lock-mode t)
(setq zone-timer nil)
(column-number-mode t)
(menu-bar-mode -1)
(tool-bar-mode -1)
(cond
 ((string= (system-name) "DANIEL-LAPTOP")
  (setq initial-frame-alist '((top . 0) (left . 0) (width . 267) (height . 67))))
 ((string= (system-name) "ubuntu")
  (set-face-attribute 'default nil :foundry "unknown" :family "Ubuntu Mono" :height 220)
  (setq initial-frame-alist '((top . 0) (left . 0) (width . 267) (height . 67))))
 ((string= (system-name) "DGALLAGHER-PC")
  (setq initial-frame-alist '((top . 0) (left . 0) (width . 267) (height . 78))))
 ((string= (system-name) "tmlsdev-laptop")
  (setq initial-frame-alist '((top . 0) (left . 0) (width . 267) (height . 80)))
  (setq compile-command "make -k -j 32")
  (set-face-attribute 'default nil :foundry "unknown" :family "Ubuntu Mono" :height 220)))

(defun set-font (height)
  (set-face-attribute 'default nil :foundry "unknown" :family "Ubuntu Mono" :height height))

(defun font-normal ()
  (interactive)
  (set-font 220))

(defun font-night ()
  (interactive)
  (set-font 260))

; Package management
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

; Enable "confusing" features
(defun no-op ())
(setq ring-bell-function 'no-op)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'set-goal-column 'disabled nil)

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
(add-hook 'before-save-hook #'(lambda () (unless (eq major-mode 'makefile-gmake-mode) (untabify 0 (point-max)))))
(add-hook 'before-save-hook #'delete-trailing-whitespace)

(add-hook 'after-save-hook
          #'(lambda ()
              (if (eq major-mode 'rust-mode)
                  (progn
                    (shell-command (concat "rustfmt " (buffer-file-name)))
                    (revert-buffer t t)))))

; Set up autoloads and keys
(add-to-list 'load-path (concat (getenv "HOME") "/.emacs.d/lisp"))

(autoload 'open-header-with-source-buffer "open-header-with-source")
(autoload 'open-header-with-source-file "open-header-with-source")
(autoload 'cweb-mode "cweb")
(autoload 'qml-mode "qml-mode")
(autoload 'go-mode "go-mode" "Major mode for editing Go source code" t)
(autoload 'zap-up-to-char "utilities" "Zap all characters before the next instance of ch" t)
(autoload 'forward-buffer "utilities")
(autoload 'backward-buffer "utilities")
(autoload 'pad-to-column "utilities" "Insert spaces up to the given column" t)
(autoload 'number-line-reset "utilities" "Reset the line number for `number-line'")
(autoload 'number-line "utilities" "Add a comment with sequential line numbers, starting at 0")
(autoload 'my-doxymacs-insert-function-comment "code-editing" "Add a function comment" t)
(autoload 'automate-add-pure-virtual "code-editing" "Add a pure virtual function" t)
(autoload 'automate-add-last-virtual "code-editing" "Insert the virtual function signature" t)
(autoload 'automate-add-last-function "code-editing" "Insert the virtual function definition" t)
(autoload 'automate-add-method "code-editing" "Insert a non-virtual method" t)
(autoload 'qfetch-to-addcolumn "code-editing" "Change QFETCH to QTest::addColumn" t)
(autoload 'class-for-current-buffer "code-editing" "Get the class name for the current buffer" t)
(autoload 'signature-to-definition "code-editing" "Change a signature to a method definition" t)
(autoload 'open-corresponding-file "code-editing" "Open the file corresponding file (header/source)" t)
(autoload 'insert-include-guard "code-editing" "Insert include guards for the header" t)
(autoload 'align-assignments "code-editing" "Align assignments in the current region" t)
(autoload 'standard-slot "code-editing" "Implement a standard value-checking slot from a declaration" t)
(autoload 'qproperty-read "code-editing" "Construct a getter declaration from a Q_PROPERTY declaration" t)
(autoload 'qproperty-write "code-editing" "Construct a setter declaration from a Q_PROPERTY declaration" t)
(autoload 'qproperty-notify "code-editing" "Construct a signal declaration from a Q_PROPERTY declaration" t)
(autoload 'qproperty-member "code-editing" "Construct a member declaration from a Q_PROPERTY declaration" t)
(autoload 'insert-test-header "code-editing" "Insert a skeleton test header" t)
(autoload 'to-display-set-definition "omc")
(autoload 'insert-enum-value "omc")
(autoload 'insert-omc-header-copyright "omc" "Insert the Optimedica copyright text for headers at the beginning of the buffer" t)
(autoload 'insert-omc-source-copyright "omc" "Insert the Optimedica copyright text for source files at the beginning of the buffer" t)
(autoload 'insert-topcon-copyright "copyright" "Insert the Topcon copyright text at the beginning of the buffer" t)
(autoload 'insert-lynx-copyright "copyright" "Insert the Lynx copyright text at the beginning of the buffer" t)
(autoload 'insert-amo-copyright "copyright" "Insert the Abbot copyright text at the beginning of the buffer" t)
(autoload 'fire-and-forget-todo "todo")
(autoload 'structure-wizard "structure" "Wizard tool to create structure files" t)
(autoload 'struct-fn "struct/all-structs" "Code generator for POD structures and helper functions" t)
(autoload 'enum-fn "struct/all-structs" "Code generator for enums and helper functions" t)
(autoload 'align-switch "code-editing" "Align a simple switch case with single-line cases" t)
(autoload 'cpp-recorded-proxy-from-signature "code-editing" "Convert a C++ signature to an implementation that records the call and forwards it to a real object")
(autoload 'cpp-recorded-and-forwarded-signal-from-signature "code-editing" "Convert a C++ signature to an implementation that records the call and re-emits a signal")
(load "banner")
(load "utilities")

(global-set-key "\M-z" 'zap-up-to-char)
(global-set-key "\M-Z" 'zap-to-char)
(global-set-key [(control ?')] 'eshell)
(global-set-key "\C-cb" 'open-header-with-source-buffer)
(global-set-key "\C-cf" 'open-header-with-source-file)
(global-set-key "\C-cp" 'auto-fill-mode)
(global-set-key "\C-x\C-m" 'execute-extended-command)
(global-set-key "\C-c\C-g" 'goto-line)
(global-set-key "\C-c(" 'show-subtree)
(global-set-key "\C-c)" 'hide-subtree)
(global-set-key "\C-c/" 'highlight-changes-mode)

(global-set-key "\C-c+" 'c++-mode)
(global-set-key "\C-cc" 'c-mode)

(global-set-key "\C-c\C-k" 'kill-region)
(global-set-key "\C-w" 'backward-kill-word)
(global-set-key [(control ?,)] 'backward-buffer)
(global-set-key [(control ?.)] 'forward-buffer)
(global-set-key (kbd "<f5>") 'compile)
(global-set-key "\C-cd" 'my-doxymacs-insert-function-comment)

(global-set-key "\C-xt" 'fire-and-forget-todo)
(global-set-key "\C-xT" 'todo-show)

; Python programming
(add-hook 'python-mode-hook
      '(lambda ()
         (local-set-key "\C-c\C-w" 'kill-region)))

; C or C++ programming
(setq c-offsets-alist
      '((arglist-intro . +)
        (arglist-close . -)
        (defun-block-intro . +)
        (substatement-open . 0)
        (statement-block-intro . +)
        (block-close . 0)
        (defun-close . -)
        (case-label . 0)
        (brace-list-open . 0)
        (access-label . -)))
(setq c-doc-comment-style
      '((java-mode . javadoc) (pike-mode . autodoc)
        (c-mode . javadoc) (c++-mode . javadoc)))

(defun c/c++-mode ()
  (local-set-key (kbd "<f6>") 'gdb)
  (local-set-key "\C-cv" 'automate-add-pure-virtual)
  (local-set-key "\C-cs" 'automate-add-last-virtual)
  (local-set-key "\C-c-" 'automate-add-last-function)
  (local-set-key "\C-cm" 'automate-add-method)
  (local-set-key "\C-cr" 'open-corresponding-file)
  (setq show-trailing-whitespace t)
  (toggle-truncate-lines t))

(add-hook 'c-mode-hook '(lambda () (c/c++-mode)))
(add-hook 'c-mode-hook 'c-turn-on-eldoc-mode)

(add-hook 'c++-mode-hook '(lambda () (c/c++-mode)))

(defun rust-mode-cfg ()
  (setq show-trailing-whitespace t)
  (toggle-truncate-lines t)
  (set-fill-column 100)
  (auto-fill-mode t))
(add-hook 'rust-mode-hook '(lambda () (rust-mode-cfg)))

(add-hook 'find-file-hook
      '(lambda ()
         (setq show-trailing-whitespace t)))

(defun switch-to-window (needle)
  (interactive "sBuffer name: ")
  (let ((start (buffer-name)))
    (other-window 1)
    (while (and (not (string= start (buffer-name)))
                (not (string= needle (buffer-name))))
      (other-window 1))))

(defadvice compile (after follow-compile first () activate)
  "Automatically scroll the compilation window"
  (let ((here (buffer-name)))
    (switch-to-window "*compilation*")
    (end-of-buffer)
    (switch-to-window here)))

(defun parenthesize-impl (b e)
  (kill-region b e)
  (insert "( ")
  (yank)
  (insert " )"))

(defun parenthesize ()
  (interactive)
  (if (region-active-p)
      (parenthesize-impl (region-beginning) (region-end))
    (let ((bounds (bounds-of-thing-at-point 'word)))
      (parenthesize-impl (car bounds) (cdr bounds)))))

; Auto-load modes
(setq auto-mode-alist (cons '("\\.w" . cweb-mode)
                            auto-mode-alist))
(setq auto-mode-alist (cons '("\\.qml" . qml-mode)
                            auto-mode-alist))
(setq auto-mode-alist (cons '("\\.go" . go-mode)
                            auto-mode-alist))

;; Fake UUID generator
(random t)
(defun insert-random-uuid ()
  "Insert a random UUID.
Example of a UUID: 1df63142-a513-c850-31a3-535fc3520c3d

WARNING: this is a simple implementation. The chance of generating the same UUID is much higher than a robust algorithm.."
  (interactive)
  (insert
   (format "{%04x%04x-%04x-4%03x-%01x%03x-%06x%06x}"
           (random (expt 16 4))
           (random (expt 16 4))
           (random (expt 16 4))
           (random (expt 16 3))
           (+ 8 (random 4))
           (random (expt 16 3))
           (random (expt 16 6))
           (random (expt 16 6)))))

; Lisp support
(setq inferior-lisp-program "/usr/bin/clisp")

; Support emacsclient as the system editor
(server-start)

; Custom setup for TMLS development
(setenv "TMLS_DEBUG" "1")

(load-theme 'tango-dark)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
