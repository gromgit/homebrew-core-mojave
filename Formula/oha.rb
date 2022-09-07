class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "96b4101bbfd65453d2bd44dea10d99b2553508fff9f5552673bf76c08d8c15f8"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oha"
    sha256 cellar: :any_skip_relocation, mojave: "838d270941fb11cd8464dfaf95176d0853ce127361c392123a26b8b9cf2fca38"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
