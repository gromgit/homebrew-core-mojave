class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/7.0.0.tar.gz"
  sha256 "94d2949972aba3a0c4d85f1ba2dd8bf818ea193fd058634aaa3bdc8e911cb838"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findomain"
    sha256 cellar: :any_skip_relocation, mojave: "fec2f76f699f058ddda9f9bfc3e7c1969a6907b7efddecdd86221ce258949824"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
