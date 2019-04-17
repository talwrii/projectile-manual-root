;;; projectile-manual-root.el --- Manual set projectile roots (useful for traversing code *installed* on the system (e.g. python, npm etc)

;; Copyright (C) 2018 Tal Wrii
;;
;; Author: Tal Wrii <talwrii@gmail.com>
;; Version: 0.0.1
;; Keywords:
;; URL: http://github.com/talwrii/projectile-manual-root
;; Package-Requires: ((s "0") )
;;
;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 59 Temple Place - Suite 330,
;; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Allow the manual setting of roots
;; Maintain a collection of "root directories" and if our current default-directory
;; falls under one such root set the projectile-project-root to this root rather than
;; using version control

;; This was motivated by trying to navigate python source code installed by apt
;; which tends to be owned by root. But may well have uses for those who want to
;; avoid using a version control system on some files for whatever reason

;;; Code:

(defvar projectile-manual-root-roots nil "List of manual projectile roots")


(defun projectile-manual-root-load-hook ()
  (interactive)
  (if-let ((root (projectile-manual-root-find-root)))
      (setq projectile-project-root  root )))

(define-minor-mode projectile-manual-root "Manually set projectile roots"
  :global t
  (if projectile-manual-root
      (add-hook 'find-file-hook 'projectile-manual-root-load-hook)
    (remove-hook 'find-file-hook 'projectile-manual-root-load-hook)))


(defun projectile-manual-root-find-root ()
  (projectile-manual-root-any
         (cl-loop for root in projectile-manual-root-roots collect
                  (if (or
                       (equal root default-directory)
                       (f-ancestor-of? root default-directory)) root))))

(defun projectile-manual-root-any (list)
  (if (null list)
      nil
    (or (car list) (projectile-manual-root-any (cdr list)))))

(defun projectile-manual-root-add ()
  (interactive)
  (setq projectile-manual-root-roots (cons default-directory
                                           (cl-loop for r in projectile-manual-root-roots if (not (or (f-ancestor-of? default-directory r)
                                                                         (f-ancestor-of? r default-directory)))
                       collect r)))
  (setq projectile-project-root-cache (make-hash-table :test 'equal))
  (projectile-manual-root-load-hook)
  (projectile-project-root))


(defun projectile-manual-root-show-roots ()
  (interactive)
  (let ((buffer (get-buffer-create "*projectile-manual-root-roots*")))
  (with-current-buffer buffer
    (erase-buffer)
    (cl-loop for r in projectile-manual-root-roots
             do (insert (s-concat r "\n"))))
  (pop-to-buffer buffer)))

(provide 'projectile-manual-root)
;;; projectile-manual-root.el ends here
