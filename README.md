## About

Vim syntax file for Sway

## Instalation

1. Clone this repo and copy the folders 'ftdetect' and 'syntax' to ~/.vim/
1. Edit your ~/.vim/filetype.vim so it may contain at least the following block

```
if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufNewFile,BufRead *.[sS][wW] setf sway
augroup END
```
