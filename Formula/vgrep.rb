class Vgrep < Formula
  desc "User-friendly pager for grep"
  homepage "https://github.com/vrothberg/vgrep"
  url "https://github.com/vrothberg/vgrep/archive/v2.6.0.tar.gz"
  sha256 "4cbd912189397b08897fcc1709787ec60ed42275059f900463055211e1f6d689"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/vrothberg/vgrep.git", branch: "main"

  # The leading `v` in this regex is intentionally non-optional, as we need to
  # exclude a few older tags that use a different version scheme and would
  # erroneously appear as newer than the newest version. We can't check the
  # "latest" release on GitHub because it's sometimes a lower version that was
  # released after a higher version (i.e., "latest" is the most recent release
  # but not necessarily the newest version in this context).
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/vgrep"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "42fef65ad0af4a4be9e778349ae281cc5950a786bb3056c3e62d98f740a34861"
  end

  depends_on "go" => :build
  depends_on "go-md2man" => :build

  def install
    system "make", "release"
    mkdir bin
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    (testpath/"test.txt").write "Hello from Homebrew!\n"
    output = shell_output("#{bin}/vgrep -w Homebrew --no-less .")
    assert_match "Hello from", output
    assert_match "Homebrew", output
  end
end
