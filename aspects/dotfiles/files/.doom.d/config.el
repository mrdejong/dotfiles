;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Alexander de Jong"
      user-mail-address "mrdejong89@gmail.com")

(setq doom-leader-key "SPC"
      doom-localleader-key ",")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-nord-light)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

(after! ranger
  (map! :leader
        :desc "Open ranger"
        "f r" #'ranger))

(after! neotree
  (map! :leader
        :desc "Open neotree"
        "f n" #'+neotree/open))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 'relative)

(after! lsp-mode
  (lsp-register-client
   (make-lsp-client :new-connection (lsp-tramp-connection '("intelephens" "--stdio"))
                    :major-modes '(php-mode)
                    :remote? t
                    :priority -1
                    :notification-handlers (ht ("indexingStarted" #'ignore)
                                               ("indexingEnded" #'ignore))
                    :initialization-options (lambda ()
                                              (list :storagePath lsp-intelephense-storage-path
                                                    :licenceKey lsp-intelephense-licence-key
                                                    :clearCache lsp-intelephense-clear-cache))
                    :completion-in-comments? t
                    :server-id 'iph-remote)))

(defun save-exit ()
  (interactive)
  (evil-normal-state)
  (save-buffer))

(defun move-one-char ()
  (interactive)
  (evil-normal-state)
  (execute-kbd-macro (read-kbd-macro "la")))

(defun move-end-line ()
  (interactive)
  (evil-normal-state)
  (execute-kbd-macro (read-kbd-macro "$a")))

(defun move-end-line-semi ()
  (interactive)
  (evil-normal-state)
  (execute-kbd-macro (read-kbd-macro "$a;"))
  (evil-normal-state))

(defun paste ()
  (interactive)
  (evil-normal-state)
  (execute-kbd-macro (read-kbd-macro "pa")))

(require 'key-chord)
(require 'key-seq)

(key-chord-mode 1)
(setq key-chord-two-keys-delay 0.2)

(key-seq-define evil-insert-state-map "jw" 'save-exit)
(key-seq-define evil-insert-state-map "jl" 'move-one-char)
(key-seq-define evil-insert-state-map "js" 'move-end-line)
(key-seq-define evil-insert-state-map "j;" 'move-end-line-semi)
(key-seq-define evil-insert-state-map "jp" 'paste)

(add-to-list 'auto-mode-alist '("\\.ts\\'" . typescript-mode))

(after! company
  (setq company-idle-delay 0.0
        company-minimum-prefix-length 2)
  (setq company-show-numbers t)
  (add-hook 'evil-normal-state-entry-hook #'company-abort))

;; exwm config
;; (require 'exwm)
;; (require 'exwm-config)
;; (exwm-config-default)
;; (require 'exwm-randr)

;; (add-hook 'exwm-randr-screen-change-hook
;;           (lambda ()
;;             (start-process-shell-command
;;              "xrandr" nil "xrandr --output HDMI-1 --primary --right-of eDP-1")))

;; (defun open-program (name command)
;;   "Open the program in a buffer called name via the command"
;;   (start-process-shell-command name nil command))

;; (defun open-brave ()
;;   "Open the brave browser"
;;   (program-prompt "Browser" "brave"))

;; (defun program-prompt (command)
;;   (interactive (list (read-shell-command "$ ")))
;;   (open-program command command))

;; (defun dc/exwm-update-class ()
;;   (exwm-workspace-rename-buffer exwm-class-name))

;; (setq exwm-input-prefix-keys
;;       '(?\C-x
;;         ?\C-u
;;         ?\C-h
;;         ?\M-x
;;         ?\M-`
;;         ?\M-&
;;         ?\M-:
;;         ?\C-\M-j))

;; (setq exwm-workspace-number 10
;;       exwm-randr-workspace-output-plist '(0 "HDMI-1"
;;                                           1 "eDP-1")
;;       exwm-input-prefix-keys '(?\M-x
;;                                ?\M-:)
;;       exwm-input-global-keys '(([?\s-p] . program-prompt)
;;                                ([?\s-v] . evil-window-vsplit)
;;                                ([?\s-z] . evil-window-split)
;;                                ([?\s-k] . evil-window-next)
;;                                ([?\s-j] . evil-window-prev)
;;                                ([?\s-S-j] . evil-window-decrease-width)
;;                                ([?\s-w] . exwm-workspace-switch)
;;                                ([?\s-c] . exwm-workspace-swap)
;;                                ([?\s-m] . exwm-workspace-move)
;;                                ([?\s-r] . exwm-reset)))


;; (exwm-randr-enable)

;; (require 'exwm-systemtray)
;; (exwm-systemtray-enable)

;; (exwm-enable)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
