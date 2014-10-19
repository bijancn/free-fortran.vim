" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
"
" .vim/syntax/fortran.vim - fast modern Fortran keyword highlighting
"
" Copyright (C) 2014         Bijan Chokoufe Nejad         <bijan@chokoufe.com>
" Recent versions:  https://github.com/bijancn/bcn_scripts
"
" This source code is free software that comes with ABSOLUTELY NO WARRANTY; you
" can redistribute it and/or modify it under the terms of the GNU GPL Version 2:
" http://www.gnu.org/licenses/gpl-2.0-standalone.html
"
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

"=========="
"  prelim  "
"=========="
" Remove any old syntax stuff hanging around
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
  w
endif

"=================="
"  keyword regexs  "
"=================="
syn match fortranComment      " *!.*$"
syn match fortranString       "\".\{-}\""
syn match fortranString       "\'.\{-}\'"
syn keyword fortranStatement  only write implicit none
syn keyword fortranStatement  do else then call
syn keyword fortranStatement  subroutine function interface module result pure elemental abstract
syn keyword fortranStatement  return exit cycle if stop private extends import associate end print read open close inquire rewind use deallocate allocate nullify select case while
syn keyword fortranBuiltin  present associated allocated len max min minloc minval int char trim sin cos tan sinh cosh tanh tan2 sqrt huge epsilon abs size
syn match fortranOperator	 "\(\(>\|<\)[ =]\|=\|=>\|+\|-\|*\|/\)"
setlocal iskeyword+=.
syn keyword fortranBoolean  .false. .true.
syn keyword fortranOperator  .and. .or. .not.
syn keyword fortranType  logical procedure complex public private save pointer target allocatable generic parameter optional

syn keyword fortranType intent dimension type class real integer character
" nextgroup is a bit expensive
" syn keyword fortranType intent dimension type class real integer character nextgroup=fortranTy
" special highlighting for the 'type argument'
" syn match fortranTy contained "(\(\w\|=\|_\|\*\)*)"

"===================="
"  linking keywords  "
"===================="
hi def link nowebChunkName     Identifier
hi def link nowebVerbatim      SpecialKey
hi def link latexMath          Special
hi def link latexSection       pandocEmphasis
hi def link latexComment	     Comment
hi def link latexStatement     Statement
hi def link fortranComment	   Comment
hi def link fortranBuiltin     SpecialKey
hi def link fortranString	     String
hi def link fortranBoolean	   Boolean
hi def link fortranOperator    Operator
hi def link fortranStatement   Statement
hi def link fortranDoStatement Statement
hi def link fortranDoName      Special
hi def link fortranType        Type
hi def link fortranTy          Include
