 ;;
 ;; Initialize markdown-mode
 ;;
 (autoload 'markdown-mode "markdown-mode"
    "major mode for editing markdown files" t)
 (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))
 (add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
 (add-to-list 'auto-mode-alist '("\\.mdwn\\'" . markdown-mode))
 (add-to-list 'auto-mode-alist '("\\.kd\\'" . markdown-mode))
 (add-to-list 'auto-mode-alist '("\\.kramdown\\'" . markdown-mode))
 (add-to-list 'auto-mode-alist '("\\.kdwn\\'" . markdown-mode))
 (add-hook 'markdown-mode-hook 'turn-on-auto-fill)
