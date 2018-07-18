# bazel-example

## Requirements

* Bazel (taken from the Ubuntu PPA)
* Nix (tested on Ubuntu 16.04, `4.15.0-24-generic`, x86_64)

## Building and running

The test library:

```
$ bazel build //engine:test-lib
```

The test binary (depends on the test library):

```
$ bazel build //engine:test-bin
$ bazel run //engine:test-bin
```

The test closure (currently fails):

```
$ bazel build //engine:test-closure
```
