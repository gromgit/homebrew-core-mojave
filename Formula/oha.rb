class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.5.tar.gz"
  sha256 "8af14d4e14373e2c0c0b6473b53e51be1ec186259f5098d11a0241817cf139a8"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oha"
    sha256 cellar: :any_skip_relocation, mojave: "8a72d7fa404e34acdd2d8e7556cc805d2db12964104433e2803fa32c032446d1"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 200 responses"
    assert_match output.to_s, shell_output("#{bin}/oha --no-tui https://www.google.com")
  end
end
