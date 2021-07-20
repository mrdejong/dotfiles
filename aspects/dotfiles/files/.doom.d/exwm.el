;;; ../.dotfiles/aspects/dotfiles/files/.doom.d/exwm.el -*- lexical-binding: t; -*-

(defun dc/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))

(defun dc/set-wallpaper ()
  (interactive)
  (start-process-shell-command
   "Nitrogen" nil "nitrogen --restore"))

(defun dc/exwm-init-hook ()
  (exwm-workspace-switch-create 1)

  (dc/start-panel)
  (dc/run-in-background "picom --experimental-backends"))

(defun dc/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun dc/exwm-update-title ()
  (pcase exwm-class-name
    ("Firefox" (exwm-workspace-rename-buffer (format "Firefox: %s" exwm-title)))))

(defun dc/configure-window-by-class ()
  (interactive)
  (pcase exwm-class-name
    ("Firefox" (exwm-workspace-switch-create 2))))

(defun dc/update-displays ()
  (dc/run-in-background "autorandr --change --force")
  (dc/set-wallpaper)
  (message "Display config: %s"
           (string-trim (shell-command-to-string "autorandr --current"))))

(defun dc/init-exwm ()
  (setq exwm-workspace-number 5)
  (add-hook 'exwm-update-class-hook #'dc/exwm-update-class)
  (add-hook 'exwm-update-title-hook #'dc/exwm-update-title)
  (add-hook 'exwm-manage-finish-hook #'dc/configure-window-by-class)
  (add-hook 'exwm-init-hook #'dc/exwm-init-hook)

  (require 'exwm-randr)
  (exwm-randr-enable)
  (start-process-shell-command "xrandr" nil "xrandr --output HDMI-1 --primary --right-of eDP-1")
  (setq exwm-randr-workspace-monitor-plist '(1 "HDMI-1" 2 "eDP-1"))
  (dc/set-wallpaper)

  (setq exwm-workspace-warp-cursor t))
