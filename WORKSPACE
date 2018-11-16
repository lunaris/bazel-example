workspace(name = "habito")

http_archive(
  name = "io_tweag_rules_nixpkgs",
  strip_prefix = "rules_nixpkgs-fd9adeb5be345108a10bad97994f45a6c4dc3b42",
  urls = ["https://github.com/tweag/rules_nixpkgs/archive/fd9adeb5be345108a10bad97994f45a6c4dc3b42.tar.gz"],
)

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl", "nixpkgs_git_repository", "nixpkgs_package")

http_archive(
  name = "io_bazel_rules_docker",
  sha256 = "29d109605e0d6f9c892584f07275b8c9260803bf0c6fcb7de2623b2bedc910bd",
  strip_prefix = "rules_docker-0.5.1",
  urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.5.1.tar.gz"],
)

load("@io_bazel_rules_docker//container:container.bzl", "container_pull", container_repositories = "repositories")
container_repositories()

container_pull(
  name = "debian",
  registry = "index.docker.io",
  repository = "library/debian",
  tag = "stretch-slim",
)

http_archive(
  name = "io_tweag_rules_haskell",
  strip_prefix = "rules_haskell-7095cdb7ed1ded5f90191db7264880b75392f61f",
  urls = ["https://github.com/tweag/rules_haskell/archive/7095cdb7ed1ded5f90191db7264880b75392f61f.tar.gz"],
)

load("@io_tweag_rules_haskell//haskell:repositories.bzl", "haskell_repositories")

nixpkgs_git_repository(
  name = "nixpkgs",
  revision = "e7ca9af4cc7ad9c1c980ba4694cc9edaedcfda19",
)

nixpkgs_package(
  name = "ghc",
  repositories = {"nixpkgs": "@nixpkgs//:default.nix"},
  attribute_path = "haskell.compiler.ghc843",
)

register_toolchains("//:ghc")

load("@io_tweag_rules_haskell//haskell:nix.bzl", "haskell_nixpkgs_packageset", "haskell_nixpkgs_packages")

haskell_nixpkgs_packageset(
  name = "hackage_packages",
  repositories = {"nixpkgs": "@nixpkgs//:default.nix"},
  nix_file = "//:haskell-packages.nix",
  base_attribute_path = "haskellPackages",
)

load("@hackage_packages//:packages.bzl", "import_packages")
import_packages(
  name = "hackage",
)
