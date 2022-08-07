class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v0.5.3.tar.gz"
  sha256 "f49c3584746d387b83038bfa58039d9edf5148d0fb625403184e8d997b673105"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/oha"
    sha256 cellar: :any_skip_relocation, mojave: "eb76b0d311d9b5ccd36586edc4b09bd342df08429b48640d136f8c3cd2a3f2bf"
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
