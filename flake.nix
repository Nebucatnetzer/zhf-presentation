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
        pdfName = "presentation";
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
            buildInputs = [
              pkgs.polylux2pdfpc
              typstEnvironment
            ];
            buildPhase = ''
              mkdir $out
              typst compile main.typ $out/${pdfName}.pdf
            '';
          };
          present = pkgs.writeShellScriptBin "present" ''
            result=$(nix build --no-link --print-out-paths)
            ${pkgs.pdfpc}/bin/pdfpc ${pdfName}.pdf
          '';
          watch = pkgs.writeShellScriptBin "typst-watch" ''
            ${typstEnvironment}/bin/typst watch src/main.typ --open xdg-open ${pdfName}.pdf
          '';
        };
        devShells.default = pkgs.mkShellNoCC {
          env = {
            inherit TYPST_FONT_PATHS;
          };
          packages = [
            pkgs.pdfpc
            pkgs.polylux2pdfpc
            pkgs.tinymist
            pkgs.typstyle
            typstEnvironment
          ];
        };
      }
    );
}
