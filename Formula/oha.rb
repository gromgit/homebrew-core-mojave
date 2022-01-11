class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/v0.5.0.tar.gz"
  sha256 "763f44ae37c27d98f0ef32eebdef94b7409f3d25208c152e50af48e4c073256c"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oha"
    sha256 cellar: :any_skip_relocation, mojave: "49414f0c285ec7428fbc6794ce90dc7319e9bae635732f6a5b96b0f1cd7e031a"
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
