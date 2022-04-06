class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "1879b2e155679241560ce805965bbd7ac5fb1b602115d97b2b31afe8a0964051"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oha"
    sha256 cellar: :any_skip_relocation, mojave: "6d0e263260fab4d5d6ba90ed9291ab2604fbdc9493629e0cab6f8806bd95094b"
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
