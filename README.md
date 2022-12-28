## About

Vim syntax file for Sway

## Installation

Pre-requisites:
1. Clone this repo
1. Ensure you have the `forc-lsp` binary with `which forc-lsp`. If not, install [the Sway toolchain](https://fuellabs.github.io/sway/v0.25.2/introduction/installation.html).

### Neovim

1. Copy the folders 'ftdetect' and 'syntax' to the config folder: 
```
cp -R ~/sway.vim/syntax ~/.config/nvim && cp -R ~/sway.vim/ftdetect ~/.config/nvim
```
2. If you do not have `~/.config/nvim/init.lua`, install [kickstart.nvim](https://github.com/nvim-lua/kickstart.nvim).
3. Add the following to `~/.config/nvim/init.lua`:
```
-- Install Sway LSP as a custom	server
local lspconfig = require 'lspconfig'
local configs = require 'lspconfig.configs'

-- Check if the config is already defined (useful when reloading this file)
if not configs.sway_lsp then
   configs.sway_lsp = {
     default_config = {
       cmd = {'forc-lsp'},
       filetypes = {'sway'},
       on_attach = on_attach,
       root_dir = function(fname)
         return lspconfig.util.find_git_ancestor(fname)
       end;
       settings = {};
     };
   }
 end

lspconfig.sway_lsp.setup{}
```
4. Check that the LSP is running by running `:LspInfo` and trying out features like Goto Definition (`gd`) and Hover (`K`). The key mappings are defined in `~/.config/nvim/init.lua`

![Nov-10-2022 20-18-51](https://user-images.githubusercontent.com/47993817/201267485-dcff3e58-1b13-4215-9c77-c262f8bebdc5.gif)

### Vim

1. Clone this repo
2. Copy the folders 'ftdetect' and 'syntax' to the config folder: 
```
cp -R ~/sway.vim/syntax ~/.vim && cp -R ~/sway.vim/ftdetect ~/.vim
```
3. Edit your `~/.vim/filetype.vim` to contain the following block:
```
if exists("did_load_filetypes")
  finish
endif

augroup filetypedetect
  au! BufNewFile,BufRead *.[sS][wW] setf sway
augroup END
```
4. Install [plug.vim](https://github.com/junegunn/vim-plug)
5. Add the following to your `~/.vimrc`
```
call plug#begin()

Plug 'prabirshrestha/vim-lsp'

call plug#end()
```
6. Create a file called `~/.vim/lsp.vim` with the following contents, or add this to an existing vim script:
```
" vim-lsp for Sway (sway-lsp)
if executable('sway-lsp')
    au User lsp_setup call lsp#register_server({
        \ 'name': 'sway-lsp',
        \ 'cmd': {server_info->['sway-lsp']},
        \ 'whitelist': ['sway'],
        \ })
endif
```
7. Open vim and `:source ~/.vim/lsp.vim`
8. Check that the LSP is running with `:LspStatus` and try out feature like `:LspDefinition` and `:LspHover`. The full list of commands are defined [here](https://github.com/prabirshrestha/vim-lsp).

![Nov-10-2022 21-05-18](https://user-images.githubusercontent.com/47993817/201267452-4b51a037-6b49-464c-92c4-c0df50c15fd4.gif)
