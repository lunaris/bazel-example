with import <nixpkgs> {};

let
  genBazelBuild =
    callPackage <bazel_haskell_wrapper> {};

  rawHaskellPackages =
    haskell.packages.ghc843;
in {
  haskellPackages = genBazelBuild rawHaskellPackages;
}
