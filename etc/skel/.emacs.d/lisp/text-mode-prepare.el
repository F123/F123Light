 ;;
 ;; text-mode stuff
 ;;
  (add-hook 'text-mode-hook
  (lambda()
    (local-set-key (kbd "C-c w") 'count-words)))

