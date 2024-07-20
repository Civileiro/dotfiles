self: super: {
  # Don't copy upstream queries from tree-sitter parsers
  # This reverts https://github.com/NixOS/nixpkgs/pull/321550
  neovimUtils = super.neovimUtils // {
    grammarToPlugin = grammar:
      let prevPlugin = super.neovimUtils.grammarToPlugin grammar;
      in prevPlugin.overrideAttrs (prevAttrs: {
        buildCommand = ''
          mkdir -p $out/parser
          ln -s ${grammar}/parser $out/parser/${
            self.lib.removePrefix "vimplugin-treesitter-grammar-" prevAttrs.name
          }.so
        '';
      });
  };
}
