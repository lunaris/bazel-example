package(default_visibility = ["//visibility:public"])

load("@io_tweag_rules_haskell//haskell:haskell.bzl",
    "haskell_binary",
    "haskell_library",
    "haskell_toolchain",
    )

load("@ai_formation_hazel//:hazel.bzl",
    "hazel_library",
    )

load("@io_bazel_rules_docker//container:container.bzl",
    "container_image",
    )

load("@io_tweag_clodl//clodl:clodl.bzl",
    "binary_closure",
    )

load("@io_bazel_rules_docker//lang:image.bzl",
    "app_layer",
    )

haskell_toolchain(
    name = "ghc",
    version = "8.2.2",
    tools = "@ghc//:bin",
    )

haskell_binary(
    name = "test-bin",
    src_strip_prefix = "bin/test/test-bin/src",
    srcs = glob(['bin/test/test-bin/src/**/*.hs']),
    deps = [
        ":test-lib",
        ],
    prebuilt_dependencies = [
        "base",
        ],
    compiler_flags = [
        "-dynamic",
        "-rdynamic",
        "-pie",
        ],
    )

binary_closure(
    name = "test-closure",
    src = "test-bin",
    excludes = [
        "ld-linux-x86-64\.so.*",
        "libgcc_s\.so.*",
        "libc\.so.*",
        "libdl\.so.*",
        "libm\.so.*",
        "libpthread\.so.*",
        ],
    )

haskell_library(
    name = "test-lib",
    src_strip_prefix = "lib/test-lib/src",
    srcs = glob(['lib/test-lib/src/**/*.hs']),
    deps = [
        hazel_library("bifunctors"),
        hazel_library("constraints"),
        hazel_library("dlist"),
        hazel_library("hashable"),
        hazel_library("lens"),
        hazel_library("mmorph"),
        hazel_library("mono-traversable"),
        hazel_library("protolude"),
        hazel_library("tagged"),
        hazel_library("text"),
        ],
    prebuilt_dependencies = [
        "base",
        "bytestring",
        "containers",
        "transformers",
        ],
    )
