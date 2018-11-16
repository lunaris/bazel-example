# bazel-example

## Requirements

* Nix (tested on Ubuntu 16.04, `4.15.0-24-generic`, x86_64)

## Building and running

The test library:

```
$ nix-shell --pure --run "bazel build //engine:test-lib"
```
