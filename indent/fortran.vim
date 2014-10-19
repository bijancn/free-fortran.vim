" Language: Fortran90,95,03,08 free form
"
" Based on the version from Ajit J. Thakkar <ajit@unb.ca>;
" <http://www.unb.ca/chem/ajit/> (2011 Dec. 28)

" Only load this indent file once but overwrite default Fortran indent
if exists("b:fortran_indented")
  finish
endif
let b:fortran_indented = 1

setlocal indentkeys+==~end,=~case,=~if,=~else,=~do,=~where,=~elsewhere,=~select
setlocal indentkeys+==~endif,=~enddo,=~endwhere,=~endselect,=~elseif
setlocal indentkeys+==~type,=~interface,=~forall,=~associate,=~block,=~enum
setlocal indentkeys+==~endforall,=~endassociate,=~endblock,=~endenum
if exists("b:fortran_indent_more") || exists("g:fortran_indent_more")
  setlocal indentkeys+==~function,=~subroutine,=~module,=~contains,=~program
  setlocal indentkeys+==~endfunction,=~endsubroutine,=~endmodule
  setlocal indentkeys+==~endprogram
endif

" Define the appropriate indent function but only once
setlocal indentexpr=FortranGetFreeIndent()
if exists("*FortranGetFreeIndent")
  finish
endif

function FortranGetIndent(lnum)
  let ind = indent(a:lnum)
  let prevline=getline(a:lnum)
  " Strip tail comment
  let prevstat=substitute(prevline, '!.*$', '', '')
  let prev2line=getline(a:lnum-1)
  let prev2stat=substitute(prev2line, '!.*$', '', '')

  "Indent do loops only if they are all guaranteed to be of do/end do type
  if exists("b:fortran_do_enddo") || exists("g:fortran_do_enddo")
    if prevstat =~? '^\s*\(\d\+\s\)\=\s*\(\a\w*\s*:\)\=\s*do\>'
      let ind = ind + &sw + g:fortran_extra_structure_indent
    endif
    if getline(v:lnum) =~? '^\s*\(\d\+\s\)\=\s*end\s*do\>'
      let ind = ind - &sw - g:fortran_extra_structure_indent
    endif
  endif

  "Add a shiftwidth to statements following if, else, else if, case,
  "where, else where, forall, type, interface and associate statements
  if prevstat=~? '^\s*\(case\|else\|else\s*if\|else\s*where\)\>'
 \ ||prevstat=~? '^\s*\(type\|interface\|abstract interface\|associate\|enum\)\>'
 \ ||prevstat=~?'^\s*\(\d\+\s\)\=\s*\(\a\w*\s*:\)\=\s*\(forall\|where\|block\)\>'
 \ ||prevstat=~? '^\s*\(\d\+\s\)\=\s*\(\a\w*\s*:\)\=\s*if\>'
     let ind = ind + &sw + g:fortran_extra_structure_indent
    " Remove unwanted indent after logical and arithmetic ifs
    if prevstat =~? '\<if\>' && prevstat !~? '\<then\>'
      let ind = ind - &sw - g:fortran_extra_structure_indent
    endif
    " Remove unwanted indent after type( statements
    if prevstat =~? '^\s*type\s*('
      let ind = ind - &sw - g:fortran_extra_structure_indent
    endif
  endif

  "Indent program units unless instructed otherwise
  if !exists("b:fortran_indent_less") && !exists("g:fortran_indent_less")
    let prefix='\(\(pure\|impure\|elemental\|recursive\)\s\+\)\{,2}'
    let type='\(\(integer\|real\|double\s\+precision\|complex\|logical'
          \.'\|character\|type\|class\)\s*\S*\s\+\)\='
    if prevstat =~? '^\s*\(module\|contains\|program\)\>'
            \ ||prevstat =~? '^\s*'.prefix.'subroutine\>'
            \ ||prevstat =~? '^\s*'.prefix.type.'function\>'
            \ ||prevstat =~? '^\s*'.type.prefix.'function\>'
      let ind = ind + &sw
    endif
    if getline(v:lnum) =~? '^\s*contains\>'
          \ ||getline(v:lnum)=~? '^\s*end\s*'
          \ .'\(function\|subroutine\|module\|program\)\>'
      let ind = ind - &sw
    endif
  endif

  "Subtract a shiftwidth from else, else if, elsewhere, case, end if,
  " end where, end select, end forall, end interface, end associate,
  " end enum, and end type statements
  if getline(v:lnum) =~? '^\s*\(\d\+\s\)\=\s*'
        \. '\(else\|else\s*if\|else\s*where\|case\|'
        \. 'end\s*\(if\|where\|select\|interface\|abstract interface\|'
        \. 'type\|forall\|associate\|enum\)\)\>'
    let ind = ind - &sw - g:fortran_extra_structure_indent
    " Fix indent for case statement immediately after select
    if prevstat =~? '\<select\s\+\(case\|type\)\>'
      let ind = ind + &sw + g:fortran_extra_structure_indent
    endif
  endif

  "First continuation line
  if prevstat =~ '&\s*$' && prev2stat !~ '&\s*$'
    let ind = ind + &sw + g:fortran_extra_continuation_indent
  endif
  "Line after last continuation line
  if prevstat !~ '&\s*$' && prev2stat =~ '&\s*$'
    let ind = ind - &sw - g:fortran_extra_continuation_indent
  endif

  return ind
endfunction

function FortranGetFreeIndent()
  "Find the previous non-blank line
  let lnum = prevnonblank(v:lnum - 1)

  "Use zero indent at the top of the file
  if lnum == 0
    return 0
  endif

  let ind=FortranGetIndent(lnum)
  return ind
endfunction
