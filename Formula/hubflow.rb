# NOTE: Pull from git tag to get submodules
class Hubflow < Formula
  desc "GitFlow for GitHub"
  homepage "https://datasift.github.io/gitflow/"
  url "https://github.com/datasift/gitflow.git",
      tag:      "1.5.3",
      revision: "ed032438d2100b826d2fd5c8281b5e07d88ab9eb"
  license "BSD-2-Clause"
  head "https://github.com/datasift/gitflow.git", branch: "master"

bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/hubflow"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "002f14a0c2dae38ff6cf54173677a13fefda047407a4edd700f313f06073e279"
  end

  def install
    ENV["INSTALL_INTO"] = libexec
    system "./install.sh", "install"
    bin.write_exec_script libexec/"git-hf"
  end

  test do
    system bin/"git-hf", "version"
  end
end
