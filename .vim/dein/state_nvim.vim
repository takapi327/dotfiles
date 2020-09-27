if g:dein#_cache_version !=# 150 || g:dein#_init_runtimepath !=# '/Users/takapi327/.vim/dein/repos/github.com/Shougo/dein.vim,/Users/takapi327/.config/nvim,/etc/xdg/nvim,/Users/takapi327/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/usr/local/Cellar/neovim/0.4.4/share/nvim/runtime,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/takapi327/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/takapi327/.config/nvim/after' | throw 'Cache loading error' | endif
let [plugins, ftplugin] = dein#load_cache_raw(['/Users/takapi327/.config/nvim/init.vim', '/Users/takapi327/.config/nvim/dein.toml', '/Users/takapi327/.config/nvim/lazy.toml'])
if empty(plugins) | throw 'Cache loading error' | endif
let g:dein#_plugins = plugins
let g:dein#_ftplugin = ftplugin
let g:dein#_base_path = '/Users/takapi327/.vim/dein'
let g:dein#_runtime_path = '/Users/takapi327/.vim/dein/.cache/init.vim/.dein'
let g:dein#_cache_path = '/Users/takapi327/.vim/dein/.cache/init.vim'
let &runtimepath = '/Users/takapi327/.vim/dein/repos/github.com/Shougo/dein.vim,/Users/takapi327/.config/nvim,/etc/xdg/nvim,/Users/takapi327/.local/share/nvim/site,/usr/local/share/nvim/site,/usr/share/nvim/site,/Users/takapi327/.vim/dein/.cache/init.vim/.dein,/usr/local/Cellar/neovim/0.4.4/share/nvim/runtime,/Users/takapi327/.vim/dein/.cache/init.vim/.dein/after,/usr/share/nvim/site/after,/usr/local/share/nvim/site/after,/Users/takapi327/.local/share/nvim/site/after,/etc/xdg/nvim/after,/Users/takapi327/.config/nvim/after'
filetype off
