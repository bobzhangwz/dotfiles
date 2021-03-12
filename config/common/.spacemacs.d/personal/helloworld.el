;;;###autoload

(defun helloworld ()
  (interactive)
  (message "hello world emacs")
  )

(defvar zh-buffer-exclude-regexps
  '("^ .*" "^\\*.*" "^\\..*")
  "if buffer name match the regexp, ignore it.")

(defun zh-buffer-list ()
  (let ((regexp (mapconcat 'identity zh-buffer-exclude-regexps "\\|"))
        b-list)
    (dolist (buffer (buffer-list))
      (if (not (string-match regexp (buffer-name buffer)))
          (setq b-list (append b-list (list buffer)))
        nil))
    b-list))

;; (1 (1 1))

(defun zh-split-window-3 ()
  (interactive)
  (let* ((buffer-l (zh-buffer-list))
         new-win)
    (setq new-win (split-window nil nil t))
    (set-window-buffer new-win (or (nth 1 buffer-l) (current-buffer)))
    (set-window-buffer (split-window new-win nil) (or (nth 2 buffer-l) (current-buffer)))))

(global-set-key "\C-c3" 'zh-split-window-3)

(define-key global-map (kbd "C-x |") 'split-window-horizontally)
(define-key global-map (kbd "C-x _") 'split-window-vertically)
(define-key global-map (kbd "C-{") 'shrink-window-horizontally)
(define-key global-map (kbd "C-}") 'enlarge-window-horizontally)
(define-key global-map (kbd "C-^") 'enlarge-window)
;; Navgating: Windmove uses C-<up> etc.
(define-key global-map (kbd "C-<up>"   ) 'windmove-up)
(define-key global-map (kbd "C-<down>" ) 'windmove-down)
(define-key global-map (kbd "C-<right>") 'windmove-right)
(define-key global-map (kbd "C-<left>" ) 'windmove-left)
(define-key global-map (kbd "M-o" ) 'other-window)
(define-key global-map (kbd "C-c C-h" ) 'holy-mode)

(provide 'helloworld)
