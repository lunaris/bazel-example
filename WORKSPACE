workspace(name = "bazel_example")

load("//bazel:repositories.bzl",
    "github_http_archive",
)

# Rules for using Nix and nixpkgs packages to power external dependencies.

github_http_archive(
    name = "io_tweag_rules_nixpkgs",
    user = "tweag",
    project = "rules_nixpkgs",
    sha = "1ec08ee8fbb64fcc05e3d4bde3d942afb083f34e",
)

load("@io_tweag_rules_nixpkgs//nixpkgs:nixpkgs.bzl",
    "nixpkgs_git_repository",
    "nixpkgs_package",
)

github_http_archive(
    name = "io_tweag_clodl",
    user = "tweag",
    project = "clodl",
    sha = "ed9be32ef539ea3645847987e11609028d6491f5",
)

# Rules for building Haskell code.

github_http_archive(
    name = "io_tweag_rules_haskell",
    user = "tweag",
    project = "rules_haskell",
    sha = "2a28637b0e9376c6c532537cb46bcc618bc04138",
)

load("@io_tweag_rules_haskell//haskell:repositories.bzl",
    "haskell_repositories",
)

haskell_repositories()

github_http_archive(
    name = "ai_formation_hazel",
    user = "FormationAI",
    project = "hazel",
    sha = "120651a238f978ed3f92bc3ec848ebc4e5d77216",
)

# Rules for using Hackage packages as external dependencies.

load("@ai_formation_hazel//:hazel.bzl",
    "hazel_repositories",
)

github_http_archive(
    name = "io_bazel_rules_docker",
    user = "bazelbuild",
    project = "rules_docker",
    sha = "2042ceaa1afbcb5fc97376dd1a06196abe4c67c5",
)

load("@io_bazel_rules_docker//container:container.bzl",
    "container_pull",
    container_repositories = "repositories",
)

container_repositories()

container_pull(
    name = "alpine",
    registry = "index.docker.io",
    repository = "library/alpine",
    tag = "3.8",
)

# Toolchain and system dependencies, managed by Nix.

# A pinned version of nixpkgs.

nixpkgs_git_repository(
    name = "nixpkgs",
    revision = "ee80654b5267b07ba10d62d143f211e0be81549e",
)

# Core toolchain for building and patching binaries so that their dynamic
# dependencies relate to the Nix store.

load("//bazel:cc.bzl", "cc_configure_custom")

nixpkgs_package(
    name = "patchelf",
    repository = "@nixpkgs",
    attribute_path = "patchelf",
    build_file_content = """
package(default_visibility= ["//visibility:public"])

sh_binary(
  name = "patchelf",
  srcs = ["bin/patchelf"],
)
"""
)

nixpkgs_package(
    name = "gcc-unwrapped",
    repository = "@nixpkgs",
    build_file_content = """
package(default_visibility = ["//visibility:public"])

filegroup(
  name = "cc",
  srcs = ["bin/gcc"],
)
"""
)

nixpkgs_package(
    name = "gcc-unwrapped.lib",
    repository = "@nixpkgs",
    build_file_content = """
package(default_visibility = ["//visibility:public"])

load("@bazel_example//bazel:cc.bzl", "patched_solib")
patched_solib(name="patched_stdcpp", lib_name="stdc++")
"""
)

nixpkgs_package(
    name = "gcc",
    repository = "@nixpkgs",
    attribute_path = "gcc",
)

nixpkgs_package(
    name = "binutils",
    repository = "@nixpkgs",
    attribute_path = "binutils"
)

cc_configure_custom(
    name = "local_config_cc",
    gcc = "@gcc//:bin/gcc",
    ld = "@binutils//:bin/ld",
)

# GHC and relevant toolchain, patched to build code that relates to the Nix
# store only.

nixpkgs_package(
    name = "c2hs",
    repository = "@nixpkgs",
    attribute_path = "haskell.packages.ghc822.c2hs",
)

nixpkgs_package(
    name = "ghc",
    repository = "@nixpkgs",
    attribute_path = "haskell.packages.ghc822.ghc",
    build_file = "//bazel:BUILD.ghc",
)

register_toolchains("@ghc//:ghc")

# External library dependencies.

# Definitions of Hackage packages in the LTS snapshot we use.

load("//bazel:packages-11.16.bzl",
    "packages",
    "core_packages",
)

hazel_repositories(
    core_packages = core_packages,
    packages = packages,
    extra_libs = {
        "stdc++": "@gcc-unwrapped.lib//:patched_stdcpp",
        "c++": "@gcc-unwrapped.lib//:patched_stdcpp"
    },
)

local_repository(
    name = "ignore_stack_work",
    path = "engine/.stack-work"
)
