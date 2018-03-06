" Only do this part when compiled with support for autocommands
if has("autocmd")
    " Template files
    "autocmd BufNewFile  *.py   0r ~/.vim/templates/python.template
    "autocmd BufNewFile  *.html 0r ~/.vim/templates/html.template
    "autocmd BufNewFile  *.css  0r ~/.vim/templates/css.template
    "autocmd BufNewFile  *.js   0r ~/.vim/templates/js.template
    " Nginx highlight
    autocmd BufRead,BufNewFile /{etc,opt}/nginx/conf/* set ft=nginx
    " Set filetypes for certain extensions
    autocmd BufNewFile,BufRead *.coffee              set filetype=coffee
    autocmd BufNewFile,BufRead *.css                 set filetype=css
    autocmd BufNewFile,BufRead *.js                  set filetype=javascript
    autocmd BufNewFile,BufRead *.json                set filetype=json     syntax=javascript
    autocmd BufNewFile,BufRead *.html,*.htm          set filetype=html
    autocmd BufNewFile,BufRead *.less                set filetype=less
    autocmd BufNewFile,BufRead *.sass                set filetype=sass
    autocmd BufNewFile,BufRead *.md,*.mkd,*.markdown set filetype=markdown
    autocmd BufNewFile,BufRead *.mustache            set filetype=mustache
    autocmd BufNewFile,BufRead *.plist               set filetype=xml
    autocmd BufNewFile,BufRead *.sql                 set filetype=mysql

  " In text files, always limit the width of text to 78 characters
  autocmd BufRead *.txt set tw=78
  " When editing a file, always jump to the last cursor position
  autocmd BufReadPost *
  \ if line("'\"") > 0 && line ("'\"") <= line("$") |
  \   exe "normal! g'\"" |
  \ endif
endif
