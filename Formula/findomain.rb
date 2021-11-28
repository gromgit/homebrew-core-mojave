class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/findomain"
  url "https://github.com/Edu4rdSHL/findomain/archive/5.0.1.tar.gz"
  sha256 "8a235bdfd5c8e63cf077929b0c3d3e0d8d704370d72103b93e701c47e524c27b"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findomain"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "1a6623b44f77c920e1775b74b6799a2ae6343a5e59352ff03f515002aafe95b1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
