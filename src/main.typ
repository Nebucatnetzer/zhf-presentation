// Update these for each event {

#let linkToGithubIssue = "https://github.com/NixOS/nixpkgs/issues/516381"
#let githubLabel = `backport release-26.05`
#let buildDate = "2026-05-16" // otherwise you get 1980-01-01

// }

#import "@preview/metropolyst:0.1.0": *

#show: metropolyst-theme.with(
  config-info(
    title: [ZHF Contribution Workflow],
    author: [Andreas Zweili, \@Nebucatnetzer],
    date: buildDate,
  ),
)

#title-slide()

#outline(title: [Overview], depth: 1)

ZHF issue with more details: https://github.com/NixOS/nixpkgs/issues/516381

= Update local nixpkgs

== Update local nixpkgs

```bash
git clone --depth=1 git@github.com:NixOS/nixpkgs.git
```

= Identify a broken package

== Identify a broken package: Package maintainers

#slide[
  - https://zh.fail/failed/overview.html
][#image("images/hydra_by_maintainers.png")]

== Identify a broken package: Package maintainers manually

```bash
nix-build maintainers/scripts/build.nix \
  --argstr maintainer YOUR_NICK
```

#image("images/nix_build_maintainers.png")

== Identify a broken package: Non-Flakes NixOS users

*Non-Flakes*

```bash
nixos-rebuild build -I nixpkgs=.
```

*Flakes*

```bash
nixos-rebuild build --override-input nixpkgs .
```

== Identify a broken package: All Hydra builds

https://malob.github.io/nix-review-tools-reports/

#image("images/reports_by_jobset.png", height: 80%)

== Identify a broken package: All Hydra builds

#image("images/problematic_dependencies.png")

== Identify a broken package: Viewing the logs on Hydra

#image("images/hydra_logs.png")

= Verify the package is broken
== Verify the package is broken: Reproduce the failure

```bash
nix-build -A NAME
```

#image("images/build_error.png")

== Verify the package is broken: Nobody else fixed it already

#image("images/search_pull_requests.png")

== Verify the package is broken: Somebody else fixed it already

Help test and review the PR.

#image("images/review_pull_request.png", height: 80%)

= Fix the package
== Fix the package: Locate the source (happy case)

#slide[
Open the REPL from within Nixpkgs with:

```bash
nix repl --file .
```

Then the path where the package is called:

```nix
builtins.unsafeGetAttrPos NAME pkgs
```

And finally its source:

```nix
NAME.meta.position
```
][
#image("images/nix_repl_f.png")
]

== Fix the package: Actually fixing the package

#image("images/git_diff.png")

= Upstream the fix

== Upstreaming the fix: Branch, commit and push

Create a new branch:

```bash
git switch --create BRANCH_NAME
```

Stage the changed files:

```bash
git add path/to/file.nix
```

Commit file (check #link("https://github.com/NixOS/nixpkgs/blob/master/CONTRIBUTING.md#commit-conventions")[CONTRIBUTING.md] for details):

```bash
git commit --message "PACKAGE_NAME: Fix build by switching to LLVM17 stdenv"
```

Add your fork as a remote:

```bash
git remote add SOME_NAME git@github.com:Nebucatnetzer/nixpkgs.git
```

Push the changes:

```bash
git push --set-upstream SOME_NAME HEAD
```

== Upstreaming the fix: Create a pull request

#image("images/git_switch.png")

== Upstreaming the fix: Create a pull request

#image("images/create_pull_request.png", height: 60%)

Label with: `ZHF Fixes` and #githubLabel and mention `#ZurichZHF` !

= Repeat!

== Link Collection
- #link(linkToGithubIssue)[ZHF Guide in Nixpkgs]
- #link("https://zh.fail/failed/overview.html")[Failures by maintainer]
- #link("https://malob.github.io/nix-review-tools-reports/")[Failures by jobset]
- #link(
    "https://nixos.org/manual/nixpkgs/stable/#sec-building-stdenv-package-in-nix-shell",
  )[Guide to changing the source a package]
- #link(
    "https://github.com/NixOS/rfcs/blob/master/rfcs/0180-broken-package-removal.md",
  )[RFC for broken leaf packages]
- #link(
    "https://github.com/Nebucatnetzer/zhf-presentation",
  )[Source to this presentation]
