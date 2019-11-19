;; Custom functions

;; amx

(defun amx/emacs-commands ()
  "Execute amx with a better prompt."
  (interactive)
  (let ((amx-prompt-string "Emacs commands: "))
    (amx)))

(defun amx/amx-major-mode-commands ()
  "Re-execute smex with major mode commands only."
  (interactive)
  (let ((amx-prompt-string (format "%s commands: " major-mode)))
    (amx-major-mode-commands)))

(defun spacemacs/ruby-toggle-breakpoint (&optional in-pipeline)
  "Add a break point, highlight it. Pass IN-PIPELINE to add using tap."
  (interactive (cond
                ((equal current-prefix-arg nil) (list nil))
                ((equal current-prefix-arg '(4)) (list t))))
  (let ((trace (cond (in-pipeline ".tap { |result| require \"pry\"; binding.pry }")
                     (t "require \"pry\"; binding.pry")))
        (line (thing-at-point 'line)))
    (if (and line (string-match trace line))
        (kill-whole-line)
      (progn
        (back-to-indentation)
        (indent-according-to-mode)
        (insert trace)
        (insert "\n")
        (indent-according-to-mode)))))

;; company

(defun company-tng-on ()
  "Enable company-tng-defaults, override TAB, RET, S-TAB key bindings."
  (company-tng-configure-default)
  (if (boundp 'company-active-map)
      (let ((keymap company-active-map))
        (define-key keymap [return] #'company-complete)
        (define-key keymap (kbd "RET") #'company-complete)
        (define-key keymap [tab] #'company-complete)
        (define-key keymap (kbd "TAB") #'company-select-next)
        (define-key keymap [backtab] nil)
        (define-key keymap (kbd "S-TAB") nil))
    (error "Not overriding company-tng keybindings")))

;; layout

(defun layouts-reset ()
  "Reset to the default set of layouts."
  (interactive)
  (progn
    ;; Kill other buffers, don't prompt for confirmation.
    (mapc 'kill-buffer
          (mapc 'switch-to-buffer
                (delq (current-buffer) (buffer-list))))
    (layouts-org)
    (layouts-dotfiles)
    (layouts-blog)
    (layouts-notes)
    (spacemacs/layout-goto-default)))

(defun layouts-org ()
  "Set up org layout."
  (interactive)
  (progn
    (spacemacs/layout-goto-default)
    (delete-other-windows)

    ;; Kill the journal buffer, since it might need to visit a new file
    (when (get-buffer "*journal*")
      (kill-buffer "*journal*"))

    (find-file (expand-file-name org-default-notes-file))
    (rename-buffer "*sprint*")
    (find-file (expand-file-name org-default-backlog-file))
    (rename-buffer "*backlog*")
    (org-journal-today)
    (rename-buffer "*journal*")
    (delete-other-windows)

    (switch-to-buffer "*sprint*")
    (split-window-right-and-focus)
    (switch-to-buffer "*backlog*")
    (split-window-below-and-focus)
    (switch-to-buffer "*journal*")

    (select-window (get-buffer-window "*sprint*"))
    (split-window-below-and-focus)
    (org-agenda-list)
    (rename-buffer "*agenda*")

    (select-window (get-buffer-window "*sprint*"))))

(defun layouts-blog ()
  "Set up blog layout."
  (interactive)
  (progn
    (persp-switch "blog")
    (delete-other-windows)
    (start-process "hugo-server" "*blog-server*" "blog-serve")
    (find-file (expand-file-name org-default-blog-file))
    (rename-buffer "*blog*")))

(defun layouts-notes ()
  "Set up notes layout."
  (interactive)
  (progn
    (persp-switch "notes")
    (delete-other-windows)
    (deft)
    (rename-buffer "*notes*")))

(defun layouts-dotfiles ()
  "Set up dotfiles layout."
  (interactive)
  (progn
    (persp-switch "dotfiles")
    (delete-other-windows)
    (spacemacs/find-dotfile)
    (rename-buffer "*init.el*")))

;; Org mode

(defun org-capture-deft-new-file ()
  "Open a new deft notes file, prompting for the file name."
  (require 'deft)
  (setq org-capture-deft--title (read-string "Title: ")
        org-capture-deft--timestamp (format-time-string "%Y%m%d%H%M%S"))

  (if (and (boundp 'org-capture-deft--title)
           (not (string-blank-p org-capture-deft--title)))
      (deft-new-file-named
        (downcase (replace-regexp-in-string " " "-" org-capture-deft--title)))
    (deft-new-file)))

(defun org-journal-find-location ()
  "Open today's journal entry."
  ;; Open today's journal, but specify a non-nil prefix argument in order to
  ;; inhibit inserting the heading; org-capture will insert the heading.
  (org-journal-new-entry t)
  ;; Position point on the journal's top-level heading so that org-capture
  ;; will add the new entry as a child entry.
  (goto-char (point-max)))

(defun org-journal-today ()
  "Open today's journal."
  (interactive)
  (org-journal-find-location)
  (goto-char (point-max)))

(defun org-notes-open-sprint ()
  "Open the sprint file."
  (interactive)
  (if (boundp 'org-default-notes-file)
      (find-file org-default-notes-file)
    (error "No `org-default-notes-file' set")))

(defun org-notes-open-backlog ()
  "Open the backlog file."
  (interactive)
  (if (boundp 'org-default-backlog-file)
      (find-file org-default-backlog-file)
    (error "No `org-default-backlog-file' set")))

;; Org Export: Hugo

(defun org-hugo-blog-open ()
  "Open Hugo blog, served locally using the default port, in a browser."
  (interactive)
  (async-shell-command "open http://127.0.0.1:1313")
  (delete-window))

(defun org-hugo-new-post-capture-template ()
  "Return `org-capture' template string for new Hugo post.
See `org-capture-templates' for more information."
  (save-match-data
    (let* ((date (format-time-string "%Y-%m-%d" (current-time)))
           (title (read-from-minibuffer "Post Title: " (format "Update %s" date)))
           (location (read-from-minibuffer "Location: " "New York"))
           (slug (org-hugo-slug title)))
      (mapconcat #'identity
                 `(
                   ,(concat "* DRAFT " title)
                   ":PROPERTIES:"
                   ,(concat ":EXPORT_FILE_NAME: " date "-" slug)
                   ,(concat ":EXPORT_HUGO_CUSTOM_FRONT_MATTER: :location " location)
                   ":END:"
                   "%?\n")
                 "\n"))))

(defun org-hugo-clean-export-deploy ()
  "Clean export destination for hugo blog, export org file to markdown, build production and deploy."
  (if (and (boundp 'hugo-base-dir)
           (boundp 'hugo-section))
      (progn
        (delete-directory (format "%s/content/%s" hugo-base-dir hugo-section) :recursive)
        (org-hugo-export-wim-to-md :all-subtrees nil :visible-only nil)
        (call-process-shell-command (format "(cd %s && bin/deploy) &" hugo-base-dir) nil 0))
    (error "Ensure HUGO_BASE_DIR and HUGO_SECTION are set as local variables")))

(define-minor-mode org-hugo-auto-clean-export-deploy-mode
  "Toggle auto cleaning the export destination using `ox-hugo'."
  :global nil
  :lighter ""
  (if org-hugo-auto-clean-export-deploy-mode
      (add-hook 'after-save-hook #'org-hugo-clean-export-deploy :append :local)
    (remove-hook 'after-save-hook #'org-hugo-clean-export-deploy :local)))

;; yasnippet

(defun yas/camelcase-file-name ()
  "Camel-case the current buffer's file name."
  (interactive)
  (let ((filename
         (file-name-nondirectory (file-name-sans-extension
                                  (or (buffer-file-name)
                                      (buffer-name (current-buffer)))))))
    (mapconcat #'capitalize (split-string filename "[_\-]") "")))

(defun yas/strip (str)
  "Extract a parameter name from STR."
  (replace-regexp-in-string ":.*$" ""
   (replace-regexp-in-string "^\s+" ""
    (replace-regexp-in-string "," ""
     str))))

(defun yas/to-field-assignment (str)
  "Make 'STR' to 'self.`STR` = `STR`'."
  (format "self.%s = %s" (yas/strip str) (yas/strip str)))

(defun yas/prepend-colon (str)
  "Make `STR' to :`STR'."
  (format ":%s" (yas/strip str)))

(defun yas/indent-level ()
  "Determine the number of spaces the current line is indented."
  (interactive)
  (string-match "[^[:space:]]" (thing-at-point 'line t)))

(defun yas/indent-string ()
  "Return a string of spaces matching the current indentation level."
  (interactive)
  (make-string (yas/indent-level) ?\s))

(defun yas/indented-newline ()
  "Newline followed by correct indentation."
  (interactive)
  (format "\n%s" (yas/indent-string)))

(defun yas/args-list ()
  "Extract an args list from the current line."
  (interactive)
  (string-match "\(.+\)" (thing-at-point 'line t)))

(defun yas/to-ruby-accessors (str)
  "Splits STR into an `attr_accesor' statement."
  (interactive)
  (mapconcat 'yas/prepend-colon (split-string str ",") ", "))

(defun yas/to-ruby-setters (str)
  "Splits STR into a sequence of field assignments."
  (interactive)
  (mapconcat 'yas/to-field-assignment
             (split-string str ",")
             (yas/indented-newline)))

;; Utilities

(defun display-and-copy-file-path ()
  "Print the path of the current buffer's file.
Depends on yankee.el."
  (interactive)
  (let ((file-path (yankee--abbreviated-project-or-home-path-to-file)))
    (kill-new file-path)
    (message file-path)))

(defun buffer-exists-p (bufname)
  "Check if a buffer with the given name BUFNAME exists."
  (not (eq nil (get-buffer bufname))))

(defun switch-to-previous-buffer ()
  "Switch to the previously open buffer.
Repeated invocations toggle between the two most recently open buffers.
Excludes the ibuffer."
  (interactive)
  (if (buffer-exists-p "*Ibuffer*")  (kill-buffer "*Ibuffer*"))
  (switch-to-buffer (other-buffer (current-buffer) 1)))

(defun split-term-window-right-and-focus ()
  "Open an `ansi-term' split to the right and focus it."
  (interactive)
  (defvar shell-default-term-shell)
  (split-window-right-and-focus)
  (ansi-term shell-default-term-shell))

(defun rerun-term-command-right ()
   "Re-issue previously issued command in terminal split to the right."
   (interactive)
   (evil-window-right 1)
   (evil-insert-state)
   (execute-kbd-macro (kbd "M-p"))
   (execute-kbd-macro (kbd "RET"))
   (evil-window-left 1))

(defun rerun-term-command-below ()
  "Re-issue previously issued command in a terminal split below."
  (interactive)
  (evil-window-down 1)
  (evil-insert-state)
  (execute-kbd-macro (kbd "M-p"))
  (execute-kbd-macro (kbd "RET"))
  (evil-window-up 1))

(defun r/cycle-theme ()
  "Cycle between dark and light scheme."
  (interactive)
  (if (eq r-current-theme r-dark-theme)
      (progn
        (r/light)
        (setq r-current-theme r-light-theme))
    (progn
      (r/dark)
      (setq r-current-theme r-dark-theme))))

(defun r/light ()
  "Switch to light theme."
  (interactive)
  (disable-theme r-dark-theme)
  (spacemacs/load-theme r-light-theme)
  (setq org-bullets-bullet-list '(" "))
  (r-org/reset-buffers)
  (beacon-mode -1))

(defun r/dark ()
  "Switch to dark theme."
  (interactive)
  (disable-theme r-light-theme)
  (spacemacs/load-theme r-dark-theme)
  (setq org-bullets-bullet-list '("› "))
  (r-org/reset-buffers)
  (beacon-mode +1))

(defun r-org/reset-buffers ()
  "Reset `org-mode' in all org buffers."
  (interactive)
  (dolist (buff (buffer-list))
    (with-current-buffer buff
      (if (string-equal "org-mode" major-mode)
          (org-mode)))))
