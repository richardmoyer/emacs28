;;; init.el --- -*- lexical-binding: t; -*-

(require 'chemacs
         (expand-file-name "chemacs.el"
                           (file-name-directory
                            (file-truename load-file-name))))
(chemacs-load-user-init)

;; this must be here to keep the package system happy, normally you do
;; `package-initialize' for real in your own init.el
;; (package-initialize)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(set-face-attribute 'default nil :font "Iosevka" :height 120)

(set-face-attribute 'variable-pitch nil :font "Cantarell" :height 120 :weight 'regular)
(load-theme 'modus-operandi)
;(load-theme 'spacemacs-light)
;(load-theme 'tomorrow)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(setq display-line-numbers-type 'relative)
(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
	       term-mode-hook
	       eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(use-package command-log-mode)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))

(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)

(use-package swiper :ensure t)
(use-package all-the-icons :ensure t)


;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline-mode 1))
(use-package doom-themes
  :config
  (doom-themes-org-config))


(use-package doom-modeline
  :init (doom-modeline-mode)
  :custom
  (doom-modeline-icon (display-graphic-p))
  (doom-modeline-mu4e t))

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :ensure t
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
         ("C-x b" . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package company
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-company-mode))

(setq company-idle-delay .2)
(setq company-minimum-prefix-length 3)
(setq company-selection-wrap-around t)
(company-tng-configure-default)

(use-package general)

;(use-package helpful
;  :custom
;  (counsel-describe-function-function #'helpful-callable)
;  (counsel-describe-variable-function #'helpful-variable)
;  :bind
;  ([remap describe-function] . counsel-describe-function)
;  ([remap describe-command] . helpful-command)
;  ([remap describe-variable] . counsel-describe-variable)
;  ([remap describe-key] . helpful-key))

(use-package helpful
  :commands (helpful-at-point
             helpful-callable
             helpful-command
             helpful-function
             helpful-key
             helpful-macro
             helpful-variable)
  :bind
  ([remap display-local-help] . helpful-at-point)
  ([remap describe-function] . helpful-callable)
  ([remap describe-variable] . helpful-variable)
  ([remap describe-symbol] . helpful-symbol)
  ([remap describe-key] . helpful-key)
  ([remap describe-command] . helpful-command))

;; (use-package savehist
;;   :ensure nil
;;   :custom
;;   (history-delete-duplicates t)
;;   (history-length 25)
;;   (savehist-file (expand-file-name (format "~/.emacs.d/history" xdg-cache)))
;;   :config (savehist-mode))

(use-package window
  :ensure nil
  :bind (("C-x 2" . vsplit-last-buffer)
         ("C-x 3" . hsplit-last-buffer)
         ;; Don't ask before killing a buffer.
         ([remap kill-buffer] . kill-this-buffer))
  :preface
  (defun hsplit-last-buffer ()
    "Focus to the last created horizontal window."
    (interactive)
    (split-window-horizontally)
    (other-window 1))

  (defun vsplit-last-buffer ()
    "Focus to the last created vertical window."
    (interactive)
    (split-window-vertically)
    (other-window 1)))

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(use-package all-the-icons-dired
  :if (display-graphic-p)
  :hook (dired-mode-hook . all-the-icons-dired-mode))

(use-package dired-hide-dotfiles
  :hook (dired-mode . dired-hide-dotfiles-mode)
  :bind (:map dired-mode-map
              ("H" . dired-hide-dotfiles-mode)))
(use-package dired-subtree
  :after dired
  :bind (:map dired-mode-map
              ("<tab>" . dired-subtree-toggle)))

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (setq blink-cursor-mode nil))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;;(use-package evil-magit
;;:after magit)

;; NOTE: Make sure to configure a GitHub token before using this package!
;; - https://magit.vc/manual/forge/Token-Creation.html#Token-Creation
;; - https://magit.vc/manual/ghub/Getting-Started.html#Getting-Started
(use-package forge)


(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

;; Org Mode Configuration ------------------------------------------------------

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Cantarell" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-agenda-include-diary t)
  (efs/org-font-setup))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))


(use-package page-break-lines)

(use-package dashboard
  :custom
  (dashboard-banner-logo-title "It ain’t over ’til it’s over")
  (dashboard-center-content t)
  (dashboard-items '((agenda)
		     (recents . 5)
                     (projects . 5)))
  (dashboard-projects-switch-function 'counsel-projectile-switch-project-by-name)
  (dashboard-set-file-icons t)
  (dashboard-set-footer nil)
  (dashboard-set-heading-icons t)
  (dashboard-set-navigator t)
  (dashboard-startup-banner 'logo)
  :config
  (dashboard-setup-startup-hook))

;(use-package dashboard
;  :init  
;  (progn
;    (setq dashboard-items '((recents . 5)
;			    (agenda)
;				     (projects . 5))))
;  :config
;  (dashboard-setup-startup-hook))
(setq initial-buffer-choice (lambda () (get-buffer-create "*dashboard*")))

(setq dashboard-week-agenda t)

(use-package elfeed
    :ensure t
    :config
    (setq elfeed-db-directory (expand-file-name "elfeed" user-emacs-directory)
          elfeed-show-entry-switch 'display-buffer)
    :bind
    ("C-x w" . elfeed ))

 (use-package elfeed-org
    :ensure t
    :config
    (elfeed-org)
    (setq rmh-elfeed-org-files (list "elfeed.org")))

(use-package elfeed-goodies)
(setq elfeed-goodies/entry-pane-position 'bottom)

(setq rmh-elfeed-org-files (list "~/org/elfeed.org"))
(global-set-key [remap list-buffers] 'ibuffer)

(setq org-agenda-diary-file "~/org/diary")
(setq calendar-mark-diary-entries-flag t)
