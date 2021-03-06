" https://gist.github.com/romainl/c0a8b57a36aec71a986f1120e1931f20
" 24 simple pseudo-text objects
" -----------------------------
" i_ i. i: i, i; i| i/ i\ i* i+ i- i#
" a_ a. a: a, a; a| a/ a\ a* a+ a- a#
for char in [ '_', '.', ':', ',', ';', '<bar>', '/', '<bslash>', '*', '+', '-', '#' ]
	execute 'xnoremap i' . char . ' :<C-u>normal! T' . char . 'vt' . char . '<CR>'
	execute 'onoremap i' . char . ' :normal vi' . char . '<CR>'
	execute 'xnoremap a' . char . ' :<C-u>normal! F' . char . 'vf' . char . '<CR>'
	execute 'onoremap a' . char . ' :normal va' . char . '<CR>'
endfor

" line pseudo-text objects
" ------------------------
" il al
xnoremap il g_o^
onoremap il :<C-u>normal vil<CR>
xnoremap al $o0
onoremap al :<C-u>normal val<CR>

" number pseudo-text object (integer and float)
" ---------------------------------------------
" in
function! VisualNumber()
	call search('\d\([^0-9\.]\|$\)', 'cW')
	normal v
	call search('\(^\|[^0-9\.]\d\)', 'becW')
endfunction
xnoremap in :<C-u>call VisualNumber()<CR>
onoremap in :<C-u>normal vin<CR>

" buffer pseudo-text objects
" --------------------------
" ia aa
xnoremap ia :<C-u>let z = @/\|1;/^./kz<CR>G??<CR>:let @/ = z<CR>V'z
onoremap ia :<C-u>normal via<CR>
xnoremap aa GoggV
onoremap aa :<C-u>normal vaa<CR>

" square brackets pseudo-text objects
" -----------------------------------
" ir ar
xnoremap ir i[
xnoremap ar a[
onoremap ir :normal vi[<CR>
onoremap ar :normal va[<CR>

" block comment pseudo-text objects
" ---------------------------------
" i? a?
xnoremap a? [*o]*
onoremap a? :<C-u>normal va?V<CR>
xnoremap i? [*jo]*k
onoremap i? :<C-u>normal vi?V<CR>

" last change pseudo-text objects
" -------------------------------
" ik ak
" xnoremap ik `]o`[
" onoremap ik :<C-u>normal vik<CR>
" onoremap ak :<C-u>normal vikV<CR>
