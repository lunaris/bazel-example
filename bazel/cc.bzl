"""Tools for working with custom C compiler toolchains and patching libraries
and binaries, typically for use against a Nix store.
"""

load("@bazel_tools//tools/cpp:cc_configure.bzl", "cc_autoconf_impl")

def _cc_configure_custom(ctx):
  overriden_tools = {
      "gcc": ctx.path(ctx.attr.gcc),
      "ld": ctx.path(ctx.attr.ld),
      }
  return cc_autoconf_impl(ctx, overriden_tools)

cc_configure_custom = repository_rule(
    implementation = _cc_configure_custom,
    attrs = {
        "gcc": attr.label(
            executable = True,
            cfg = "host",
            allow_single_file = True,
            doc = "`gcc` to use in cc toolchain",
            ),
        "ld": attr.label(
            executable = True,
            cfg = "host",
            allow_single_file = True,
            doc = "`ld` to use in cc toolchain",
            ),
        },
    local = True,
)

def _patched_solib_impl(ctx):
    src = ctx.file.src
    if ctx.attr.is_darwin:
        output = ctx.actions.declare_file("lib" + ctx.attr.name + ".dylib")
        ctx.actions.run_shell(
            inputs = [src],
            outputs = [output],
            progress_message = "Patching dylib %s" % ctx.label,
            command = "cp {src} {out}".format(
                src = src.path,
                out = output.path,
                ),
            )
    else:
        output = ctx.actions.declare_file("lib" + ctx.label.name + ".so")
        ctx.actions.run_shell(
            inputs = [src, ctx.executable._patchelf],
            outputs = [output],
            progress_message = "Patching solib %s" % ctx.label,
            command = ("cp {src} {out} && chmod +w {out} && "
                      + "{patchelf} --set-soname {outname} {out}").format(
                        src = src.path,
                        out = output.path,
                        patchelf = ctx.executable._patchelf.path,
                        outname = output.basename,
                        ),
            )

    return [DefaultInfo(files=depset([output]))]

_patched_solib = rule(
    _patched_solib_impl,
    attrs = {
        "src": attr.label(allow_files = True, single_file = True),
        "_patchelf": attr.label(
            default = Label("@patchelf//:patchelf"),
            executable = True,
            cfg = "host",
            ),
        "is_darwin": attr.bool(),
        },
    )

def patched_solib(name, lib_name):
    _patched_solib(
        name = name,
        src = native.glob(["lib/lib" + lib_name + ext for ext in [".so", ".dylib"]])[0],
        is_darwin = select({
            "@bazel_tools//src/conditions:darwin": True,
            "//conditions:default": False,
            }),
        )
