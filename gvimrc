set guifont=Source\ Code\ Pro\ Light:h11
set linespace=2
set antialias

" Don't beep
set visualbell

set guioptions-=T   " No toolbar
set guioptions-=r   " No scrollbars

if has("gui_macvim")
  " Fullscreen takes up entire screen
  set fuoptions=maxhorz,maxvert
end

if has("statusline") && !&cp
  " Powerline statusline config
  let g:Powerline_symbols = 'fancy'
  let g:Powerline_theme = 'solarized256'
  let g:Powerline_colorscheme = 'solarized256'
endif
