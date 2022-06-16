class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/v6.3.1.tar.gz"
  sha256 "851b91e14dc3e9c973a1870acdc5f2938ad51a12877e64e7716d9e9ae91ce389"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/keydb"
    sha256 cellar: :any, mojave: "125742b31787c23da08455194f537192a2a4da5d476821330f9dc3f5da8e0449"
  end

  depends_on "openssl@3"
  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
