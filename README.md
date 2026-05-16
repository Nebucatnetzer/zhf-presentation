# Presentation for the bi-yearly ZHF event in Rapperswil

Before building the presentation make sure that you update the variables at the top of `src/main.typ`.

Build with:

```bash
nix build
```

Develop and compile ad-hoc with:

```bash
nix run .#watch
```

NOTE This script is intended to be run on Linux as it uses `xdg-open` you can use plain `typst watch src/main.typ` on other plattforms.

To present:

```bash
nix run .#present
```
