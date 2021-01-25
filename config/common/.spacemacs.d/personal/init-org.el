(use-package org-protocol)

(with-eval-after-load 'org
    (setq org-directory "~/notes/"
          org-default-notes-file (concat org-directory "inbox.org"))

    (setq org-agenda-files (list (concat org-directory "gtd")
                                 (concat org-directory "inbox.org"))
          org-refile-targets '((nil :maxlevel . 9)
                               (org-agenda-files :maxlevel . 9))
          org-startup-with-inline-images t
          org-refile-use-outline-path t
          org-ellipsis "ζ"
          org-agenda-include-diary t
          org-indent-mode nil
          org-superstar-headline-bullets-list '("壹" "贰" "叁"
                                                "肆" "伍" "陆")
          ;; org-superstar-headline-bullets-list '("α" "β" "ε"
          ;;                                       "δ" "ζ" "θ"
          ;;                                       "ι" "η")
          org-todo-keywords '((sequence "PLAN(p)" "STARTED(s!)" "|" "COMPLETE(o!)" "CANCELLED(c@/!)")
                              (sequence "TODO(t)" "|" "DONE(d!)"))
          org-tag-alist '(("@work" . ?w) ("@home" . ?h) ("laptop" . ?l))
          org-use-fast-todo-selection t
          ;; org-agenda-custom-commands '(("w" todo "WAITING")
          ;;                              ("u" tags "+boss-urgent")
          ;;                              ("v" tags-todo "+boss-urgent"))

          org-capture-templates '(
                                  ("b" "Book Reading" entry (file+olp org-default-notes-file "Reading" "Book")
                                   "** PLAN %^{Book}\n    %u\n" :clock-in t :clock-resume t)

                                  ("t" "Todo" entry (file+headline org-default-notes-file "Todo")
                                   "** TODO %^{Task}\n    %u\n" :clock-in t :clock-resume t)

                                  ("i" "Ideas" entry (file+headline org-default-notes-file "Ideas")
                                   "** %^{Idea}\n\n")

                                  ("j" "Journal" entry (file+datetree "journal.org")
                                   "* %U - %^{heading}\n  %?")

                                  ("n" "Notes" entry (file+headline org-default-notes-file "Notes")
                                   "** %U - %^{heading} %^g\n %?\n")

                                  )
          org-todo-keyword-faces '(("TODO" . (:foreground "white" :background "#95A5A6"   :weight bold))
                                   ("PLAN" . (:foreground "white" :background "#95A5A6"   :weight bold))
                                   ("STARTED" . (:foreground "white" :background "#2E8B57"  :weight bold))
                                   ("DONE" . (:foreground "white" :background "#3498DB" :weight bold))
                                   ("COMPLETE" . (:foreground "white" :background "#3498DB" :weight bold))
                                   ("CANCELLED" . (:foreground "white" :background "#AA5AEE" :weight bold)))
          )
    )
(provide 'init-org)
