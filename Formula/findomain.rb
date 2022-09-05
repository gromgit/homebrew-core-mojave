class Findomain < Formula
  desc "Cross-platform subdomain enumerator"
  homepage "https://github.com/Findomain/Findomain"
  url "https://github.com/Findomain/Findomain/archive/8.2.1.tar.gz"
  sha256 "93c580c9773e991e1073b9b597bb7ccf77f54cebfb9761e4b1180ff97fb15bf6"
  license "GPL-3.0-or-later"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/findomain"
    sha256 cellar: :any_skip_relocation, mojave: "fb1be5fa4693a51c41e954d5d452f7819f75bb8556cf7a170350cdf8a50b2a4b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Good luck Hax0r", shell_output("#{bin}/findomain -t brew.sh")
  end
end
