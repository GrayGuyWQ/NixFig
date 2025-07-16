{ config, pkgs, ... }:

{ 
  home.username = "gray";
  home.homeDirectory = "/home/gray";
  home.stateVersion = "25.05";
  home.packages = with pkgs; [
    
    
    #Languages
    nodejs
    python3

    #LSP servers
    nil #Nix
    lua-language-server #Lua
    marksman #Markdown
    nodePackages.typescript-language-server #TypeScript/JavaScript
    pyright #Python
    rust-analyzer #Rust
    gopls #Go
    clang-tools #C/C++ (Includes clangd)

    #Formatters 
    stylua #Lua formatter
    alejandra #Nix formatter
    nodePackages.prettier #JS/TS/HTML/CSS formatter
    python312Packages.black
    ];



  programs.neovim = {
    enable = true;
    defaultEditor = true;

    #Adding languages for plugins
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;

    #Plugins
    plugins = with pkgs.vimPlugins; [
    
    	#File explorer
	nvim-tree-lua

	#Status line
	lualine-nvim

	#Colorscheme
	dracula-nvim

	#Git integration
	vim-fugitive

	#LSP support
	nvim-lspconfig #Config for different LSP servers
	nvim-cmp #Autocompletion source
	cmp-nvim-lsp #LSP source for nvim-cmp
	luasnip #Lua snippet engine

	nvim-treesitter.withAllGrammars
	];
    extraConfig = ''
      lua << EOF
        -- 'init.lua' content
	${builtins.readFile ./nvim/init.lua}
  EOF
    '';

  };
}
