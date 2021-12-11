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
    rebuild 2
    sha256 cellar: :any_skip_relocation, mojave: "2f99b1b064f1b5f0bd241af192c131c02179986dbcd9d4e0b49c1670e1dc8334"
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
