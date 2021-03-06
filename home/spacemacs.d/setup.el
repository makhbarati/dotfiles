;;; setup.el --- Emacs configuration customizations.

;;; Commentary:

;;; Code:
(require 'funcs)
(require 'editorconfig)

(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))
(add-to-list 'default-frame-alist '(ns-appearance . dark))

(setq-default projectile-completion-system 'helm
              projectile-enable-caching t
              projectile-find-dir-includes-top-level t
              projectile-project-search-path '("~/Projects" "~/Work" "~/Resources" "~/Exercism"))

(with-eval-after-load 'org
  (add-hook 'org-mode-hook #'variable-pitch-mode)
  (setq-default
   org-adapt-indentation t
   org-agenda-block-separator ""
   org-babel-python-command "python3"
   org-blank-before-new-entry '((heading . auto) (plain-list-item . auto))
   org-bullets-bullet-list '("› ")
   org-catch-invisible-edits 'show-and-error
   org-clock-idle-time 5
   org-confirm-babel-evaluate nil
   org-cycle-separator-lines 2
   org-edit-src-content-indentation 0
   org-list-use-circular-motion t
   org-ellipsis " ▾ "
   org-export-coding-system 'utf-8
   org-export-with-sub-superscripts nil
   org-fontify-done-headline t
   org-fontify-quote-and-verse-blocks t
   org-fontify-whole-heading-line t
   org-hide-emphasis-markers t
   org-image-actual-width 500
   org-md-headline-style 'setext
   org-modules '(org-bibtex org-docview org-habit org-info)
   org-pretty-entities t
   org-src-ask-before-returning-to-edit-buffer nil
   org-src-window-setup 'current-window
   org-src-tab-acts-natively t
   org-startup-indented t
   spaceline-org-clock-p t))

;; Pre-config
(config/frames)

(config/amx)
(config/compilation-buffers)
(config/copy-as-format)
(config/elixir)
(config/elm)
(config/evil-collection)
(config/evil-goggles)
(config/evil-in-ex-buffer)
(config/evil-lion)
(config/flycheck)
(config/google-translate)
(config/gtags)
(config/helpful)
(config/highlight-lines-at-length 80)
(config/ido)
(config/javascript-modes)
(config/latex-mode)
(config/ligatures)
(config/lisps)
(config/markdown-mode)
(config/org-latex-preview)
(config/org-mode)
(config/projectile)
(config/python)
(config/ruby)
(config/ruby-in-buffer-eval)
(config/ruby-folding)
(config/set-terminal-emacs-theme)
(config/shell-buffers)
(config/smartparens)
(config/underscore-to-word-char-list)
(config/version-control)
(config/web-beautify)
(config/web-mode)
(config/window-splitting)
(config/yankee)

;; compilation buffer
(setq-default compilation-scroll-output 'first-error)

;; lsp
(add-hook 'elixir-mode-hook #'lsp)

;; tramp
(setq-default tramp-default-method "ssh")

;; ledger
(add-hook 'ledger-mode-hook #'evil-ledger-mode)

;; treemacs
(treemacs-resize-icons 15)

(setq-default ispell-program-name "ispell")

;; Mac-like keybindings
(setq-default mac-command-modifier 'super)

;; display emoji as emoji
(defun --set-emoji-font (frame)
  "Adjust the font settings of FRAME so Emacs can display emoji properly."
  (if (eq system-type 'darwin)
      ;; For NS/Cocoa
      (set-fontset-font t 'symbol (font-spec :family "Apple Color Emoji") frame 'prepend)
    ;; For Linux
    (set-fontset-font t 'symbol (font-spec :family "Symbola") frame 'prepend)))

;; For when Emacs is started in GUI mode:
(--set-emoji-font nil)

;; Hook for when a frame is created with emacsclient
(add-hook 'after-make-frame-functions '--set-emoji-font)

(add-hook 'after-init-hook #'global-emojify-mode)
(set-fontset-font t 'unicode "Apple Color Emoji" nil 'prepend)

;; globally enabled minor modes
(add-hook 'after-init-hook #'visual-line-mode)
(global-evil-quickscope-mode 1)
(global-evil-matchit-mode 1)
(global-company-mode)
(smartparens-global-strict-mode)

;; Transparency
(setq-default dotspacemacs-active-transparency 95
              dotspacemacs-inactive-transparency 85)

(spacemacs/enable-transparency)
(add-hook 'after-make-frame-functions #'spacemacs/enable-transparency)
(beacon-mode +1)
(editorconfig-mode 1)

;; webkit
(setq-default browse-url-browser-function 'xwidget-webkit-browse-url)

;; Post-config
(config/prettify-symbols)
(config/company)
(config/load-local-config)

(provide 'setup)
;;; setup.el ends here
