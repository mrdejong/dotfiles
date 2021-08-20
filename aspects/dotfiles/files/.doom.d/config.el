(setq user-full-name "Alexander de Jong"
      user-mail-address "mrdejong89@gmail.com")

(setq doom-leader-key "SPC"
      doom-localleader-key ",")

(setq doom-theme 'doom-nord-light)
(setq org-directory "~/org/")

(setq display-line-numbers-type 'relative)

(map! :leader
      :desc "Open ranger"
      :nv "f r" #'ranger)

(map! :leader
      :desc "Open neotree"
      :nv "f n" #'+neotree/open)

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
