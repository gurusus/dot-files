(require 'org)         ;; The org-mode goodness
(require 'ob)          ;; org-mode export system
(require 'ob-tangle)   ;; org-mode tangling process


(message "starting  loading scripts.")


(defconst dot-files-src  (file-name-directory (or load-file-name buffer-file-name)))
(message "The name of this buffer is: %s." dot-files-src)


(defvar script-funcs-src (concat dot-files-src "elisp/shell-script-funcs.el"))


(require 'shell-script-funcs script-funcs-src)

(defconst tl/emacs-directory (concat (getenv "HOME") "/.emacs.d/"))

;; Where all of the .el files will live and play:
(defconst dest-elisp-dir (tl/get-path "${tl/emacs-directory}/elisp"))

;; The Script Part ... here we do all the building and compilation work.



(defun tl/build-dot-files ()
  "Compile and deploy 'init files' in this directory."
  (interactive)

  ;; Initially create some of the destination directories
  ;;(ha/mkdir "$HOME/.oh-my-zsh/themes")
  ;;(tl/mkdir "${tl/emacs-directory}/elisp")
  ;;(tl/mkdir "${tl/emacs-directory}/latex_templates") 
  (tl/mkdir "$HOME/bin")
  (tl/mkdir "$HOME/backup")
  (tl/tangle-files "${dot-files-src}/*.org")

  ;; Some Elisp files are just symlinked instead of tangled...
  (message "Make links to el files.")
  (tl/mksymlinks "${dot-files-src}/elisp"
                 "${tl/emacs-directory}/elisp")
  (message "done Make links to el files.")
  
  ;; copy my latex templates
  (tl/mksymlinks "${dot-files-src}/latex_templates"
                 "${tl/emacs-directory}/latex_templates")
  
  (tl/mksymlinks "${dot-files-src}/templates"
                 "${tl/emacs-directory}/templates")
  
                 

  ;; Just link the entire directory instead of copying the snippets:
  ;;(ha/mksymlink  "${dot-files-src}/snippets"
  ;;              "${ha/emacs-directory}/snippets")

  ;; Just link the entire directory instead of copying the snippets:
  ;;(ha/mksymlink  "${dot-files-src}/templates"
  ;;               "${ha/emacs-directory}/templates")

  ;; Some Elisp files are just symlinked instead of tangled...
  ;;(ha/mksymlinks "${dot-files-src}/bin/[a-z]*"
  ;;               "${HOME}/bin")

  ;; Yeah, this makes me snicker every time I see it.
  ;;(ha/mksymlink  "${dot-files-src}/vimrc" "${HOME}/.vimrc")

  ;; All of the .el files I've eithe tangled or linked should be comp'd:
  ;; (mapc 'byte-compile-file
  ;;       (ha/get-files "${ha/emacs-directory}/elisp/*.el" t))

  (message "Finished building dot-files- Resetting Emacs.")
  ;;(require 'config-main (tl/get-path "${user-emacs-directory}elisp/config-main.el"))
  )



(defun tl/tangle-file (file)
  "Given an 'org-mode' FILE, tangle the source code."
  (interactive "fOrg File: ")
  (find-file file)   ;;  (expand-file-name file \"$DIR\")
  (org-babel-tangle)
  (kill-buffer))


(defun tl/tangle-files (path)
  "Given a directory, PATH, of 'org-mode' files, tangle source code out of all literate programming files."
  (interactive "D")
  (message "The name of this buffer is: %s." (tl/get-files path))
  (mapc 'tl/tangle-file (tl/get-files path)))


;;(defun ha/get-dot-files ()
;; "Pull and build latest from the Github repository.  Load the resulting Lisp code."
;;  (interactive)
;;  (let ((git-results
;;         (shell-command (concat "cd " dot-files-src "; git pull"))))
;;    (if (not (= git-results 0))
;;        (message "Can't pull the goodness. Pull from git by hand.")
;;     (load-file (concat dot-files-src "/emacs.d/shell-script-funcs.el"))
;;     (load-file (concat dot-files-src "/build.el"))
;;      (require 'init-main))))

(tl/build-dot-files)  ;; Do it
(kill-emacs)
(provide 'dot-files)
;;; build.el ends here
