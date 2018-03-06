if has('statusline')
    set statusline+=%<%F            " file path + name
    set statusline+=\%h%m%r         " flags
                                    " %h : help flag
                                    " %m : [+] if modified, [-] if not modifiable
                                    " %r : read only flag
    set statusline+=\ [
    set statusline+=\%{&ff}:        " Fileformat (dos/unix)
    set statusline+=\%Y:            " Filetype
    set statusline+=\%{&encoding}   " Encoding
    set statusline+=\%{((exists(\"+bomb\")\ &&\ &bomb)?\":BOM\":\":-\")}
    set statusline+=\]
    if exists("g:loaded_syntastic_plugin")
        set statusline+=\ %{SyntasticStatuslineFlag()}
    endif
    set statusline+=\ %{strftime(\"%c\",getftime(expand(\"%:p\")))} " modified
    set statusline+=%=              " right alignment
    "set statusline+=%{synIDattr(synID(line('.'),col('.'),1),'name')}
    set statusline+=line:%l\,       " X line of x lines
    set statusline+=\%L             " x line of X lines
    set statusline+=\ col:%c%V      " column
    set statusline+=\ pos:%o        " cursor position
    set statusline+=\ %p%%          " percentage of file

    set laststatus=2
    set listchars=tab:▶━,trail:⌴,extends:▶,precedes:◀
endif
