class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/EQ-Alpha/KeyDB/archive/v6.2.2.tar.gz"
  sha256 "e65eea13500c30c65f705121b67cffeb3551a1c7cc7d07b60fe6191acd4dec58"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/keydb"
    sha256 cellar: :any_skip_relocation, mojave: "b04a717ae1556fd4ae7373d9fcec99fc25c9380355fa2c0090ebfa6bd24e17b6"
  end

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
