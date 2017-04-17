
 (load-file "/usr/local/src/emacspeak/lisp/emacspeak-setup.el")



;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)


(setq custom-file "~/.emacs.d/custom.el")
(load custom-file)

;; load-path stuff
(let ((default-directory "~/.emacs.d/lisp/"))(setq load-path
(append
(let ((load-path (copy-sequence load-path))) ;; Shadow
(append
(copy-sequence (normal-top-level-add-to-load-path '(".")))
(normal-top-level-add-subdirs-to-load-path)))
load-path)))

;; load personal libraries
(load-library "elpa-prepare.el")
(load-library "markdown-prepare")
(load-library "org-prepare.el")
;;(load-library "abbrev-prepare")
(load-library "text-mode-prepare")
(load-library "c-code-folding-prepare")

;; I want to evaluate elisp
(put 'eval-expression 'disabled nil)

;; No line numbers
(setq line-number-mode nil)

;; No splash screen
(setq inhibit-splash-screen t)


(defalias 'word-count 'count-words)

;; Set end key to go to the end of the current line
(global-set-key (kbd "<select>") 'move-end-of-line)

;; set f5 to go to line number
(global-set-key [f5] 'goto-line)

;; f6 and f7 to goto beginning and end of buffer
(global-set-key [f6] 'beginning-of-buffer)
(global-set-key [f7] 'end-of-buffer)

