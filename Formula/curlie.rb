class Curlie < Formula
  desc "Power of curl, ease of use of httpie"
  homepage "https://curlie.io"
  url "https://github.com/rs/curlie/archive/refs/tags/v1.6.9.tar.gz"
  sha256 "95b7061861aa8d608f9df0d63a11206f8cd532295ca13dd39ed37e0136bdcc5f"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/curlie"
    sha256 cellar: :any_skip_relocation, mojave: "bb9cbbb7ca13f987707332837474404f606c499d9f411db18d88e5d86d995cb6"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  uses_from_macos "curl"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "httpbin.org",
      shell_output("#{bin}/curlie -X GET httpbin.org/headers 2>&1")
  end
end
