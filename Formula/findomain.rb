class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/6.1.0.tar.gz"
  sha256 "5499bf1b07be83bb2d08be43bdeace77b19a461e81fb773e2ec89f5b01b52e85"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findomain"
    sha256 cellar: :any_skip_relocation, mojave: "8b579885426a07cd4cb7d594b3d20047f15583dde62fd626a7011aab90d0f5b4"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
