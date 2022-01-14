class Keydb < Formula
  desc "Multithreaded fork of Redis"
  homepage "https://keydb.dev"
  url "https://github.com/EQ-Alpha/KeyDB/archive/v6.2.1.tar.gz"
  sha256 "9376b5e14f317840cfd05fee06467e6ad7612e32da98bcb8991f5674d61d550b"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/keydb"
    sha256 cellar: :any_skip_relocation, mojave: "bac0d91b7fbf1a88d33262087a16a8a81d2b861e13c33ff4228d0611fbd229f1"
  end

  uses_from_macos "curl"

  on_linux do
    depends_on "util-linux"
  end

  # Fix build on macOS (https://github.com/EQ-Alpha/KeyDB/issues/384)
  # Patch accepted upstream, remove on next release
  patch do
    url "https://github.com/EQ-Alpha/KeyDB/commit/7a32ec39fdb738e9c3cd2b73ee18355ced793a65.patch?full_index=1"
    sha256 "06d29f24ff08032f3c211f1c322ba50f64dda9d40fbbe914ce16d8553fd68870"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    output = shell_output("#{bin}/keydb-server --test-memory 2")
    assert_match "Your memory passed this test", output
  end
end
