(defun ghost-text-html-to-md ()
  (interactive)
  (call-process-region (point-min) (point-max)
                       "pandoc" t (current-buffer) nil
                       "-f" "html"
                       "-t" "gfm-raw_html"
                       ))

(defun ghost-text-md-to-html ()
  (interactive)
  (call-process-region (point-min) (point-max)
                       "pandoc" t (current-buffer) nil
                       "-t" "html"
                       "-f" "gfm"
                       ))
