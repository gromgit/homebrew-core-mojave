class Snowball < Formula
  desc "Stemming algorithms"
  homepage "https://snowballstem.org"
  url "https://github.com/snowballstem/snowball/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "425cdb5fba13a01db59a1713780f0662e984204f402d3dae1525bda9e6d30f1a"
  license "BSD-3-Clause"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-mojave/releases/download/snowball"
    sha256 cellar: :any_skip_relocation, mojave: "791297c02b70b32946061c2d3ee49167da82e1f6effd6742b833495dc2ed2d3f"
  end

  def install
    system "make"

    lib.install "libstemmer.a"
    include.install Dir["include/*"]
    pkgshare.install "examples"
  end

  test do
    (testpath/"test.txt").write("connection")
    cp pkgshare/"examples/stemwords.c", testpath
    system ENV.cc, "stemwords.c", "-L#{lib}", "-lstemmer", "-o", "test"
    assert_equal "connect\n", shell_output("./test -i test.txt")
  end
end
