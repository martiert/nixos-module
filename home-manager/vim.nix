{ pkgs, lib, config, ...}:

let
  copilot_lua = pkgs.callPackage ./copilot.lua {};
in lib.mkIf (config.martiert.system.type != "server") {
  programs.neovim = {
    enable = true;
    vimAlias = true;
    defaultEditor = true;
    withRuby = false;

    plugins = with pkgs.vimPlugins; [
      ctrlp
      fugitive
      cpsm
      rainbow

      LanguageClient-neovim

      coc-tsserver
      coc-pyright
      vim-nix
      copilot_lua
    ];

    extraConfig = ''
      colorscheme desert

      set nocompatible
      set list
      set listchars=tab:>-
      set number
      set expandtab
      set softtabstop=4
      set shiftwidth=4
      set tabstop=4
  
      au BufNewFile,BufRead genmake.def     set syntax=python
      au BufNewFile,BufRead genmake.def     setfiletype python
      au BufNewFile,BufRead *.nix           setfiletype nix
      au BufNewFile,BufRead *.ts            setfiletype javascript
      au BufNewFile,BufRead *.tsx           setfiletype javascript
  
      filetype plugin indent on
      autocmd FileType typescript,javascript,html,xml,tex,nix setlocal shiftwidth=2 softtabstop=2
  
      let g:rainbow_active = 1
      let g:rainbow_conf = {
        \   'ctermfgs': [
        \     'darkcyan',
        \     'green',
        \     'yellow',
        \     'red',
        \     'darkmagenta',
        \   ]
        \ }
  
      let g:LanguageClient_serverCommands = {
        \ 'cpp': ['${pkgs.ccls}/bin/ccls'],
        \ 'c': ['${pkgs.ccls}/bin/ccls'],
        \ 'python': ['pylsp'],
        \ 'js': ['javascript-typescript-langserver', '--strict'],
        \ 'java': ['${pkgs.java-language-server}/bin/java-language-server'],
        \ 'kotlin': ['${pkgs.kotlin-language-server}/bin/kotlin-language-server'],
        \ }
      nmap <silent> gd <Plug>(lcn-definition)
      nmap <silent> gr <Plug>(lcn-references)
      nmap <silent> gi <Plug>(lcn-implementation)
      nmap <silent> gmv <Plug>(lcn-rename)
      nmap <silent>K <Plug>(lcn-hover)
    '';
    extraLuaConfig = ''
      require("copilot").setup({
        panel = {
          auto_refresh = true,
          enabled = true,
          layout = {
            position = "left"
          }
        },
        suggestion = {
          auto_trigger = true,
          keymap = {
            accept_word = "<C-Right>",
            deny_word = "<C-End>"
          }
        },
        filetype = {
          markdown = true,
          gitcommit = true
        },
        copilot_node_command = "${pkgs.nodejs}/bin/node",
      })
    '';
  };
}
