 ;;
 ;; c-mode code-folding key-bindings
 ;;
  (add-hook 'c-mode-common-hook
  (lambda()
    (local-set-key (kbd "C-c <right>") 'hs-show-block)
    (local-set-key (kbd "C-c <left>") 'hs-hide-block)
    (local-set-key (kbd "C-c <up>") 'hs-hide-all)
    (local-set-key (kbd "C-c <down>") 'hs-show-all)
    (hs-minor-mode t)))
