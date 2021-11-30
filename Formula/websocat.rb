class Websocat < Formula
  desc "Command-line client for WebSockets"
  homepage "https://github.com/vi/websocat"
  url "https://github.com/vi/websocat/archive/v1.9.0.tar.gz"
  sha256 "8ad0d3048662e321af11fc7e9e66d9fa4bebcd9aefad6e56c97df7d7eaab6b44"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/websocat"
    rebuild 1
    sha256 cellar: :any_skip_relocation, mojave: "6c3bbc8462a1e614ceb7b433c081ded198d542d93938ed5693800eefe16e4398"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", "--features", "ssl", *std_cargo_args
  end

  test do
    system "#{bin}/websocat", "-t", "literal:qwe", "assert:qwe"
  end
end
