# Projectile-manual-root

A minor mode for emacs that allows one to specify a collection of root directories that
projectile uses in addition to those roots derived from version control.
This was motivated by a desired to easily navigate apt-installed python source code.

# Usage

* Place `projectile-manual-root.el` on the load-path.
* Add `(require 'projectile-manual-root)` to your start up script (`init.el`) and evaluate it
* Run `(projectile-manual-root-add)` in those directories that you wish to be project roots.
* Add entries like `(add-to-list projectile-manual-root-roots "/my/directory")` if you want these roots to be persisted


* Other libraries written by the author

If you liked this library, you might be interested in other [tools written by the
author](https://github.com/talwrii/tools), including [orgnav](https://melpa.org/#/orgnav) a library to quickly navigate org files.
