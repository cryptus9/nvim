# nvim config setup

This repo should live under `user/.config/`

1. Install nvim `brew install neovim`
2. Since i use the rewrite of Treesitter (main branch) the cli is needed `brew install tree-sitter-cli`
3. Install ripgrep for fuzzy search `brew install ripgrep
4. Install jdk with brew `brew install openjdk@21`
5. Add java to $HOME `export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"`
6. Inside neovim run `:MasonInstall jdtls`

> have node installed for mason to work
