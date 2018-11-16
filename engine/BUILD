package(default_visibility = ["//visibility:public"])

load("@io_tweag_rules_haskell//haskell:haskell.bzl", "haskell_library", "haskell_toolchain")

haskell_toolchain(
    name = "ghc",
    version = "8.4.3",
    tools = "@ghc//:bin",
)

haskell_library(
    name = "test-lib",
    src_strip_prefix = "lib/test-lib/src",
    srcs = glob(['lib/test-lib/src/**/*.hs']),
    deps = [
        "@hackage//:base",
        "@hackage//:bytestring",
        "@hackage//:containers",
        "@hackage//:transformers",
        "@hackage//:bifunctors",
        "@hackage//:constraints",
        "@hackage//:dlist",
        "@hackage//:hashable",
        "@hackage//:lens",
        "@hackage//:mmorph",
        "@hackage//:mono-traversable",
        "@hackage//:protolude",
        "@hackage//:tagged",
        "@hackage//:text",
    ],
)
