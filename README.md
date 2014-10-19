free-fortran.vim
================

Faster syntax and indentation for free-form Fortran

indent
--------------------------------------------------------------------------------

- `g:fortran_extra_structure_indent`: set this to the number of spaces you want
  to additionally indent for `if`, `else`, `where`, `case`, `interface`, `type`,
  `forall`. When you have
  `shiftwidth=2`, use `let g:fortran_extra_structure_indent=1` for Emacs
  defaults.
