class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/Snapchat/KeyDB/archive/v6.3.0.tar.gz"
  sha256 "58793c1ed2f0afc81582a6216844ef9e9b1b4d3ceb8a9bbda5b34ed1b1e17e0c"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/keydb"
    sha256 cellar: :any, mojave: "00db732186d6e29a0b0066bca790345c38c91a79c9446b38d393dfa38c3742af"
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
