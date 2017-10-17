
  ;; Org-mode stuff from Rill
  '(org-export-backends (quote (ascii txt html latex md org odt)))
 '(org-export-copy-to-kill-ring t)
 '(org-export-with-email t)
 '(org-export-with-toc t)
'(org-from-is-user-regexp nil)
 (require 'org-install)
 (require 'ox-md)
 (require 'ox-ascii)
(require 'ox-html)
 (require 'ox-odt)
 (require 'ox-publish)
