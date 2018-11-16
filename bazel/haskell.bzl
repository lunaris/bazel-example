load("@io_bazel_rules_docker//container:container.bzl", "container_image")
load("@io_tweag_rules_haskell//haskell:haskell.bzl", "haskell_binary", "haskell_library")

WARNINGS = [
    "-Wall",
    "-Werror",
    "-Wimplicit-prelude",
    "-Wincomplete-record-updates",
    "-Wmissing-home-modules",
    "-Wnoncanonical-monad-instances",
    "-Wnoncanonical-monoid-instances",
    "-Wpartial-fields",
    "-Wsemigroup",
]

LANGUAGE_PRAGMAS = [
    "-XBangPatterns",
    "-XConstraintKinds",
    "-XDataKinds",
    "-XDefaultSignatures",
    "-XDeriveDataTypeable",
    "-XDeriveFoldable",
    "-XDeriveFunctor",
    "-XDeriveGeneric",
    "-XDeriveTraversable",
    "-XFlexibleContexts",
    "-XFlexibleInstances",
    "-XFunctionalDependencies",
    "-XGADTs",
    "-XGeneralizedNewtypeDeriving",
    "-XInstanceSigs",
    "-XKindSignatures",
    "-XLambdaCase",
    "-XMagicHash",
    "-XMultiParamTypeClasses",
    "-XNamedFieldPuns",
    "-XNoImplicitPrelude",
    "-XOverloadedStrings",
    "-XPatternSynonyms",
    "-XPolyKinds",
    "-XQuasiQuotes",
    "-XRankNTypes",
    "-XRecordWildCards",
    "-XScopedTypeVariables",
    "-XStandaloneDeriving",
    "-XTupleSections",
    "-XTypeApplications",
    "-XTypeFamilies",
    "-XTypeOperators",
    "-XViewPatterns",
]

def habito_library(name, **kwargs):
    haskell_library(
        name = name,
        compiler_flags = WARNINGS + LANGUAGE_PRAGMAS,
        **kwargs
    )

def habito_binary(name, **kwargs):
    haskell_binary(
        name = name,
        compiler_flags = WARNINGS + LANGUAGE_PRAGMAS,
        **kwargs
    )

def habito_image(name, **kwargs):
    haskell_image(
        name = name,
        base = "@debian//image",
        compiler_flags = WARNINGS + LANGUAGE_PRAGMAS,
        **kwargs
    )

def habito_projection_image(name, deps = [], **kwargs):
    habito_image(
        name = name,
        deps = deps + [
            "//engine/lib/habit",
            "//engine/lib/habito-cqrs:projector",
            "//engine/lib/habito-executables",
            "//engine/lib/habito-postgresql:api",

            "@hackage//:base",
        ],
        **kwargs
    )

def habito_worker_image(name, deps = [], **kwargs):
    habito_image(
        name = name,
        deps = deps + [
            "//engine/lib/habit",
            "//engine/lib/habito-executables",

            "@hackage//:base",
            "@hackage//:exceptions",
            "@hackage//:generic-lens",
            "@hackage//:monad-control",
            "@hackage//:transformers",
            "@hackage//:transformers-base",
            "@hackage//:unliftio-core",
        ],
        **kwargs
    )

def haskell_image(name, base = None, deps = [], layers = [], **kwargs):
    if layers:
        print("haskell_image does not benefit from layers=[], got: %s" % layers)

    binary_name = name + "@binary"
    binary_label = ":" + binary_name

    patched_binary_name = name + "@patched-binary"
    patched_binary_label = ":" + patched_binary_name
    patched_binary_output = name + ".patched-binary"

    libraries_name = name + "@libraries"
    libraries_label = ":" + libraries_name
    libraries_output = name + ".libraries.tar"

    kwargs.pop("linkstatic", None)

    haskell_binary(
        name = binary_name,
        deps = deps,
        linkstatic = True,
        **kwargs
    )

    native.genrule(
        name = patched_binary_name,
        srcs = [binary_label],
        outs = [patched_binary_output],
        cmd = """
          set -euo pipefail
          tmpfile=$$(mktemp)

          cp -L $(location {binary}) $$tmpfile
          loader=$$(ldd $(location {binary}) | grep 'ld-linux' | awk '{{ print $$3 }}')
          patchelf --set-interpreter $$loader $$tmpfile
          strip $$tmpfile
          cp $$tmpfile $@
          rm $$tmpfile
        """.format(
            binary = binary_label,
        )
    )

    native.genrule(
        name = libraries_name,
        srcs = [binary_label],
        outs = [libraries_output],
        cmd = """
          set -euo pipefail
          tmpdir=$$(mktemp -d)
          filesfrom=$$(mktemp)

          ldd $(location {binary}) \
              | grep '=> /' \
              | awk '{{ print $$3 }}' > $$filesfrom

          rsync --files-from=$$filesfrom --copy-links -q / $$tmpdir
          tar -cf $@ -C $$tmpdir .
          chmod -R 777 $$tmpdir
          rm -rf $$tmpdir
        """.format(
            binary = binary_label,
        )
    )

    visibility = kwargs.get("visibility", None)
    tags = kwargs.get("tags", None)
    args = kwargs.get("args")
    data = kwargs.get("data")

    container_image(
        name = name,
        base = base,
        files = [patched_binary_label],
        tars = [libraries_label],
        visibility = visibility,
        entrypoint = "/" + patched_binary_output,
        tags = tags,
        args = args,
        data = data,
        legacy_run_behavior = False,
    )
