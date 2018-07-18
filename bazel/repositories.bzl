"""Tools for working with types of repositories other than those provided natively by Bazel"""

def github_http_archive(name, user, project, sha):
  native.http_archive(
      name = name,
      urls = ["https://github.com/{}/{}/archive/{}.tar.gz".format(
          user, project, sha)],
      strip_prefix = "{}-{}".format(project, sha),
      )
