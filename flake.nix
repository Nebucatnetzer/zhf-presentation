{
  description = "Presentation for the bi-yearly ZHF event in Rapperswil";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        fonts = pkgs.symlinkJoin {
          name = "typst-fonts";
          paths = [
            pkgs.fira
          ];
        };
        TYPST_FONT_PATHS = "${fonts}/share/fonts";
        typstEnvironment = pkgs.typst.withPackages (p: [
          p.metropolyst
          p.polylux
        ]);
      in
      {
        packages = {
          default = pkgs.stdenvNoCC.mkDerivation {
            inherit TYPST_FONT_PATHS;
            name = "zhf-presentation";
            src = ./src;
            buildInputs = [ typstEnvironment ];
            buildPhase = ''
              mkdir $out
              typst compile main.typ $out/presentation.pdf
            '';
          };
          watch = pkgs.writeShellScriptBin "typst-watch" ''
            ${typstEnvironment}/bin/typst watch src/main.typ --open xdg-open presentation.pdf
          '';
        };
        devShells.default = pkgs.mkShellNoCC {
          env = {
            inherit TYPST_FONT_PATHS;
          };
          packages = [
            pkgs.typstyle
            pkgs.tinymist
            typstEnvironment
          ];
        };
      }
    );
}
