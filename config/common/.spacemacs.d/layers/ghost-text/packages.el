(setq ghost-text-packages
      '(atomic-chrome))

(defun ghost-text/init-atomic-chrome ()
  (use-package atomic-chrome
    :defer t
    :init
    (setq atomic-chrome-default-major-mode 'markdown-mode
          atomic-chrome-buffer-open-style 'full)

    )
    :config
    (with-eval-after-load 'atomic-chrome
      (define-key atomic-chrome-edit-mode-map (kbd "C-c m") 'ghost-text-html-to-md)
      (define-key atomic-chrome-edit-mode-map (kbd "C-c h") 'ghost-text-md-to-html)
      )
  )
