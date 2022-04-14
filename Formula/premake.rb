class Premake < Formula
  desc "Write once, build anywhere Lua-based build system"
  homepage "https://premake.github.io/"
  url "https://github.com/premake/premake-core/releases/download/v5.0.0-beta1/premake-5.0.0-beta1-src.zip"
  sha256 "07b77cac3aacd4bcacd5ce0d1269332cb260363b78c2a8ae7718f4016bf2892f"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/premake/premake-core.git", branch: "master"

  livecheck do
    url "https://premake.github.io/download/"
    regex(/href=.*?premake[._-]v?(\d+(?:\.\d+)+(?:[._-][a-z]+\d*)?)[._-]src\.zip/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/premake"
    sha256 cellar: :any_skip_relocation, mojave: "d9d158c41c99c309f13903902766106d705c81c87f33737f66735d0ae7311c6e"
  end

  def install
    if build.head?
      platform = OS.mac? ? "osx" : "linux"
      system "make", "-f", "Bootstrap.mak", platform
      system "./bin/release/premake5", "gmake2"
      system "./bin/release/premake5", "embed"
      system "make"
    else
      platform = OS.mac? ? "macosx" : "unix"
      system "make", "-C", "build/gmake2.#{platform}", "config=release"
    end
    bin.install "bin/release/premake5"
  end

  test do
    expected_version = build.head? ? "-dev" : version.to_s
    assert_match expected_version, shell_output("#{bin}/premake5 --version")
  end
end
