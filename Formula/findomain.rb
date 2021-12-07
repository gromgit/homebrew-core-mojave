class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/5.0.1.tar.gz"
  sha256 "8a235bdfd5c8e63cf077929b0c3d3e0d8d704370d72103b93e701c47e524c27b"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findomain"
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "b909e86eba40131f24101a24a97043c2948781a78ed9e27b8d3a473bdb32e4e4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
